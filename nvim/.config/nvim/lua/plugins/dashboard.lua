-- Start page.
--
-- The header is the Legora mark, rendered one of two ways:
--
--   1. image - the real PNG, drawn by Snacks.image over the Kitty graphics
--              protocol. Ghostty, Kitty, and herdr panes (herdr speaks the
--              protocol itself, as kitty_virtual_placeholder).
--   2. ascii - the mark generated from its own geometry. Works anywhere.
--
-- Three things about this were learned the hard way and are load-bearing:
--
-- * The image is NOT produced by chafa in a `terminal` section. A terminal
--   section runs its command inside nvim's own terminal emulator, and libvterm
--   swallows Kitty graphics escapes instead of forwarding them, so the area
--   renders empty. Snacks.image writes Kitty unicode placeholders straight to
--   the tty, which is what actually arrives.
--
-- * Capability cannot be decided at startup. snacks decides by *querying* the
--   terminal, which needs a real tty, so a headless or early check reports
--   false even on Ghostty. logo_tier() only picks the layout; the real check
--   runs per dashboard buffer.
--
-- * The FileType autocmd must be registered BEFORE Snacks.setup(). setup()
--   opens the dashboard synchronously, so registering afterwards misses the
--   event entirely and the image never gets placed. Placement also has to wait
--   for the buffer to be written: snacks renders by setting lines, which drops
--   any extmark already there.
--
-- Override with vim.g.dashboard_logo = "kitty" | "ascii", and see what was
-- chosen with :DashboardLogoTier
--
-- The asset is generated from geometry, not traced: a square with a 90-degree
-- arc carved out of three corners and a square notch in the fourth (top right).

local LOGO_PNG = vim.fn.stdpath("config") .. "/assets/legora-mark-light.png"
local LOGO_HEIGHT = 12
local LOGO_WIDTH = 24

-- Fallback mark. Padded to equal width because each line is centred on its own.
local LOGO_ASCII = {
  "        ▄         ",
  "        █         ",
  "      ▄██         ",
  "    ▄████         ",
  "▄▄▄██████         ",
  "▀▀▀████████████▀▀▀",
  "    ▀████████▀    ",
  "      ▀████▀      ",
  "        ██        ",
  "        ▀▀        ",
}

---Is there an env var with this prefix? Multiplexers announce themselves with
---prefixed variables (HERDR_PANE_ID, CMUX_TAB_ID, ...) rather than a bare name,
---so checking the bare name finds nothing.
---@param prefix string
---@return boolean
local function has_env_prefix(prefix)
  for name in pairs(vim.fn.environ()) do
    if name:find(prefix, 1, true) == 1 then
      return true
    end
  end
  return false
end

---Are we inside a multiplexer that will *not* carry graphics escapes through?
---
---herdr is deliberately absent. Measured inside a real herdr pane, snacks
---reports supports_terminal() = true and env name "ghostty", so both the
---capability query and the graphics themselves survive a pane.
---@return boolean
local function in_blind_multiplexer()
  if vim.env.TMUX or vim.env.ZELLIJ or vim.env.STY or vim.env.TERM_PROGRAM == "tmux" then
    return true
  end
  return has_env_prefix("CMUX_")
end

---Layout guess, made at startup before any tty is available to query.
---@return "kitty"|"ascii"
local function logo_tier()
  local forced = vim.g.dashboard_logo
  if forced == "kitty" or forced == "ascii" then
    return forced
  end
  if not vim.uv.fs_stat(LOGO_PNG) then
    return "ascii"
  end
  if in_blind_multiplexer() then
    return "ascii"
  end
  -- herdr counts as capable even though TERM inside a pane degrades to
  -- xterm-256color, which is why this cannot rely on TERM alone.
  if has_env_prefix("HERDR_") then
    return "kitty"
  end
  local prog = (vim.env.TERM_PROGRAM or ""):lower()
  local term = (vim.env.TERM or ""):lower()
  local capable = prog:find("ghostty", 1, true)
    or prog:find("kitty", 1, true)
    or term:find("ghostty", 1, true)
    or term:find("kitty", 1, true)
    or vim.env.KITTY_WINDOW_ID ~= nil
  return capable and "kitty" or "ascii"
end

local function logo_section()
  if logo_tier() == "ascii" then
    -- preset.header, which snacks centres for us. `text` would want Text chunk
    -- tables rather than plain strings.
    return { section = "header", padding = 1 }
  end
  -- Reserve a blank block for the image to be drawn over.
  local blank = {}
  for _ = 1, LOGO_HEIGHT do
    table.insert(blank, string.rep(" ", LOGO_WIDTH))
  end
  return { text = table.concat(blank, "\n"), align = "center", padding = 1 }
end

---Write the ASCII mark into the reserved block, for when the terminal turns out
---not to support graphics after all.
---@param buf number
---@param width number
local function fill_with_ascii(buf, width)
  local pad = math.max(0, math.floor((width - #LOGO_ASCII[1]) / 2))
  local lines = {}
  for _, l in ipairs(LOGO_ASCII) do
    table.insert(lines, string.rep(" ", pad) .. l)
  end
  while #lines < LOGO_HEIGHT do
    table.insert(lines, "")
  end
  local was = vim.bo[buf].modifiable
  vim.bo[buf].modifiable = true
  pcall(vim.api.nvim_buf_set_lines, buf, 0, LOGO_HEIGHT, false, lines)
  vim.bo[buf].modifiable = was
  vim.bo[buf].modified = false
end

---@param buf number
local function place_logo(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "snacks_dashboard" then
    return
  end
  local win = vim.fn.bufwinid(buf)
  local width = win ~= -1 and vim.api.nvim_win_get_width(win) or vim.o.columns

  -- Authoritative check, only meaningful once there is a tty to query.
  if not Snacks.image.supports_terminal() then
    fill_with_ascii(buf, width)
    return
  end

  Snacks.image.placement.clean(buf) -- drop any copy from a previous render
  local col = math.max(0, math.floor((width - LOGO_WIDTH) / 2))
  local ok = pcall(Snacks.image.placement.new, buf, LOGO_PNG, {
    pos = { 1, col },
    width = LOGO_WIDTH,
    auto_resize = true,
  })
  if not ok then
    fill_with_ascii(buf, width)
  end
end

---Poll until snacks has written the dashboard lines, then place the image.
---@param buf number
---@param attempt? number
local function place_when_ready(buf, attempt)
  attempt = attempt or 1
  if attempt > 40 or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if vim.api.nvim_buf_line_count(buf) <= LOGO_HEIGHT then
    vim.defer_fn(function()
      place_when_ready(buf, attempt + 1)
    end, 25)
    return
  end
  place_logo(buf)
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Only these two. snacks is a bundle and the rest stays off on purpose;
      -- see docs/TRIAGE.md. `image` also makes opening a .png render inline.
      image = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = table.concat(LOGO_ASCII, "\n"),
          keys = {
            { icon = " ", key = "f", desc = "Find file", action = ":Telescope find_files" },
            { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent files", action = ":Telescope oldfiles" },
            { icon = " ", key = "g", desc = "Find text", action = ":Telescope live_grep" },
            {
              icon = " ",
              key = "e",
              desc = "Explorer",
              action = function()
                require("mini.files").open(vim.uv.cwd(), true)
              end,
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = function()
                vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
              end,
            },
            { icon = "󰒲 ", key = "l", desc = "Plugins", action = ":Lazy" },
            { icon = " ", key = "m", desc = "Language servers", action = ":Mason" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          logo_section(),
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- The mark in green. The brand forest green (~#0b5033) is too dark to read
      -- on a dark background, so the asset and this are both lifted versions.
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#2f9e63" })
      vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#928374", italic = true })

      -- Find the dashboard buffer by polling rather than by autocmd.
      --
      -- FileType is not usable here: snacks sets the dashboard buffer options
      -- during startup in a way that the event never reaches a handler
      -- registered from this config, whether before or after setup(). Polling
      -- for a snacks_dashboard buffer that has been written is event-agnostic
      -- and costs a handful of 25ms timer ticks at startup only.
      if logo_tier() == "kitty" then
        local function scan(attempt)
          attempt = attempt or 1
          if attempt > 80 then
            return
          end
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if
              vim.api.nvim_buf_is_valid(buf)
              and vim.bo[buf].filetype == "snacks_dashboard"
              and vim.api.nvim_buf_line_count(buf) > LOGO_HEIGHT
            then
              place_logo(buf)
              return
            end
          end
          vim.defer_fn(function()
            scan(attempt + 1)
          end, 25)
        end
        scan()
      end

      vim.api.nvim_create_user_command("DashboardLogoTier", function()
        vim.notify(
          ("dashboard logo: layout=%s  terminal_graphics=%s"):format(
            logo_tier(),
            tostring(Snacks.image.supports_terminal())
          ),
          vim.log.levels.INFO
        )
      end, { desc = "Which logo tier the dashboard chose" })
    end,
  },
}
