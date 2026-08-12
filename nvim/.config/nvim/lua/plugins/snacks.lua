-- snacks.nvim: the start page, plus the QoL modules we actually want.
--
-- snacks is a bundle of ~34 modules, all opt-in. Enabled here:
--
--   dashboard - start page (most of this file is its logo handling)
--   image     - inline image rendering
--   indent    - indent guides and scope           (vs indent-blankline)
--   notifier  - notifications, replaces vim.notify (vs nvim-notify)
--   input     - better vim.ui.input               (vs dressing, now archived)
--   words     - highlight LSP references under the cursor
--   scroll    - smooth scrolling                  (vs neoscroll)
--
-- Everything else stays off: picker (telescope does that), explorer
-- (mini.files), terminal, zen, dim, statuscolumn, animate, scratch, profiler.
--
-- START PAGE
--
-- The header is the Legora mark, rendered one of two ways:
--
--   1. image - the real PNG, drawn by Snacks.image over the Kitty graphics
--              protocol. Ghostty or Kitty, including inside herdr when
--              experimental.kitty_graphics is enabled there.
--   2. ascii - the mark generated from its own geometry. Works anywhere, and is
--              the fallback wherever graphics cannot be carried.
--
-- See lua/util/graphics.lua for how capability is decided: a multiplexer only
-- counts as capable if it actually carries graphics. herdr does, but only with
-- experimental.kitty_graphics = true in its config, so that flag is read.
--
-- Two further things here are load-bearing:
--
-- * The image is NOT produced by chafa in a `terminal` section. A terminal
--   section runs its command inside nvim's own terminal emulator, and libvterm
--   swallows Kitty graphics escapes rather than forwarding them, so the area
--   renders empty. Snacks.image writes to the tty directly.
--
-- * The dashboard buffer is found by polling, not by FileType. snacks sets the
--   dashboard buffer's options during startup such that the event never reaches
--   a handler registered from this config, whether registered before or after
--   Snacks.setup(). Placement also has to wait for the lines to exist, since
--   snacks renders by setting lines and that drops any extmark already there.
--
-- Override with vim.g.dashboard_logo = "kitty" | "ascii", or turn images off
-- everywhere with vim.g.images_enabled = false. :DashboardLogoTier reports what
-- was chosen and why.
--
-- The asset is generated from geometry, not traced: a square with a 90-degree
-- arc carved out of three corners and a square notch in the fourth (top right).

local graphics = require("util.graphics")

local LOGO_PNG = vim.fn.stdpath("config") .. "/assets/legora-mark-light.png"
local LOGO_HEIGHT = 12
local LOGO_WIDTH = 12

-- Padded to equal width because each line is centred on its own.
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

---Layout choice, made at startup before any tty is available to query.
---@return "kitty"|"ascii"
local function logo_tier()
  local forced = vim.g.dashboard_logo
  if forced == "kitty" or forced == "ascii" then
    return forced
  end
  if not vim.uv.fs_stat(LOGO_PNG) then
    return "ascii"
  end
  return graphics.likely() and "kitty" or "ascii"
end

local function logo_section()
  if logo_tier() == "ascii" then
    -- preset.header, which snacks centres for us. `text` would want Text chunk
    -- tables rather than plain strings.
    return { section = "header", padding = 1 }
  end
  -- ONE line, not LOGO_HEIGHT of them.
  --
  -- Snacks.image makes its own vertical space: the placement extmark carries
  -- virt_lines sized to the image (9 of them at this width). Reserving a block
  -- as well stacked 12 blank lines on top of those, so the mark sat far above a
  -- menu pushed 20-odd rows down. The single line is just an anchor.
  -- padding = 0 so the mark sits directly on top of the first menu item; the
  -- image's own virt_lines already provide its height.
  return { text = string.rep(" ", LOGO_WIDTH), align = "center", padding = 0 }
end

---Write the ASCII mark into the reserved block, for when the image cannot be
---drawn after all.
---@param buf number
---@param width number
local function fill_with_ascii(buf, width)
  local pad = math.max(0, math.floor((width - #LOGO_ASCII[1]) / 2))
  local lines = {}
  for _, l in ipairs(LOGO_ASCII) do
    table.insert(lines, string.rep(" ", pad) .. l)
  end
  local modifiable = vim.bo[buf].modifiable
  vim.bo[buf].modifiable = true
  -- Replaces the single anchor line, so the rest of the page shifts down by the
  -- height of the mark rather than overwriting the menu.
  pcall(vim.api.nvim_buf_set_lines, buf, 0, 1, false, lines)
  vim.bo[buf].modifiable = modifiable
  vim.bo[buf].modified = false
end

---@param buf number
local function place_logo(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "snacks_dashboard" then
    return
  end
  local win = vim.fn.bufwinid(buf)
  local width = win ~= -1 and vim.api.nvim_win_get_width(win) or vim.o.columns

  if not graphics.supported() then
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

---Poll for the dashboard buffer, then place the image once it has content.
---@param attempt? number
local function place_when_ready(attempt)
  attempt = attempt or 1
  if attempt > 80 then
    return
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].filetype == "snacks_dashboard"
      -- LOGO_HEIGHT is used purely as a "has snacks written the page yet"
      -- threshold; the rendered dashboard is far taller than this.
      and vim.api.nvim_buf_line_count(buf) > LOGO_HEIGHT
    then
      place_logo(buf)
      return
    end
  end
  vim.defer_fn(function()
    place_when_ready(attempt + 1)
  end, 25)
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      return {
        -- image is switched off entirely where graphics cannot work. Left on, it
        -- would clear an image file's buffer and render nothing, which looks
        -- broken; off, the file simply is not treated as an image.
        image = { enabled = graphics.likely() },

        -- Indent guides, plus a brighter line for the current scope.
        indent = {
          enabled = true,
          indent = { char = "│" },
          scope = { enabled = true, char = "│" },
          -- The animation on scope change is distracting while editing
          animate = { enabled = false },
        },

        -- Takes over vim.notify. Compact style so LSP chatter stays small.
        notifier = {
          enabled = true,
          timeout = 3000,
          style = "compact",
          top_down = false, -- notifications rise from the bottom right
        },

        -- Replaces the single-line prompt for vim.ui.input, which is what
        -- mini.files' rename and grug-far style prompts use.
        input = { enabled = true },

        -- Underline the other references to the symbol under the cursor.
        words = { enabled = true, debounce = 200 },

        -- Smooth scrolling. Short duration: long ones feel laggy rather than
        -- smooth once you are moving quickly.
        scroll = {
          enabled = true,
          animate = { duration = { step = 10, total = 120 }, easing = "linear" },
        },
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
      }
    end,
    config = function(_, opts)
      require("snacks").setup(opts)

      -- The mark in green. The brand forest green (~#0b5033) is too dark to read
      -- on a dark background, so the asset and this are both lifted versions.
      vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#2f9e63" })
      vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = "#928374", italic = true })

      if logo_tier() == "kitty" then
        place_when_ready()
      end

      vim.api.nvim_create_user_command("DashboardLogoTier", function()
        vim.notify(
          table.concat({
            "layout               = " .. logo_tier(),
            "blocks_graphics      = " .. tostring(graphics.blocks_graphics()),
            "herdr_kitty_graphics = " .. tostring(graphics.herdr_kitty_graphics()),
            "terminal_capable     = " .. tostring(graphics.terminal_looks_capable()),
            "images_usable        = " .. tostring(graphics.supported()),
          }, "\n"),
          vim.log.levels.INFO
        )
      end, { desc = "Why the dashboard picked its logo tier" })
    end,
  },
}
