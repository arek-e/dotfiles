-- Start page.
--
-- Renders the Legora mark two ways, best first, so the start page is never
-- broken regardless of where nvim is running:
--
--   1. kitty - a real image over the Kitty graphics protocol, via chafa.
--              Verified to emit a genuine _Ga= graphics escape (RGBA, 240x240
--              in 24x12 cells). Ghostty and Kitty only.
--   2. ascii - the mark generated from its own geometry. No external anything.
--
-- chafa's `symbols` mode was measured as a middle tier and dropped: at 24x12 it
-- only picks lower-half blocks, which halves the vertical resolution and reads
-- as a diamond rather than the mark. The hand-generated ASCII below is simply
-- better at this size, so there is no reason for an intermediate step.
--
-- Tier 1 needs the terminal to pass graphics escapes through. Multiplexers have
-- to opt into that, so any detected multiplexer drops to ascii rather than
-- gambling and painting escape-code litter over the screen. Override with
--   vim.g.dashboard_logo = "kitty" | "ascii"
-- and check what was chosen with :DashboardLogoTier
--
-- The asset is generated from geometry, not traced: a square with a 90-degree
-- arc carved out of three corners and a square notch in the fourth (top right).

local LOGO_PNG = vim.fn.stdpath("config") .. "/assets/legora-mark-light.png"
local LOGO_HEIGHT = 12
local LOGO_WIDTH = 24

-- Final fallback. Padded to equal width because each line is centred on its own.
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
---herdr is deliberately absent from this list. herdr 0.7.5 implements the Kitty
---graphics protocol: its API exposes pane.graphics.set / clear / info and
---PaneGraphicsSetParams (image_width, image_height, data_base64, placement),
---and its renderer handles kitty_virtual_placeholder. So graphics are expected
---to survive a herdr pane, and it gets the image tier.
---
---If that turns out to be wrong in practice, the symptom is escape-code litter
---on the start page; set vim.g.dashboard_logo = "ascii" to pin the fallback.
---@return boolean
local function in_blind_multiplexer()
  if vim.env.TMUX or vim.env.ZELLIJ or vim.env.STY or vim.env.TERM_PROGRAM == "tmux" then
    return true
  end
  return has_env_prefix("CMUX_")
end

---Which rendering tier this environment can actually manage.
---@return "kitty"|"ascii"
local function logo_tier()
  local forced = vim.g.dashboard_logo
  if forced == "kitty" or forced == "ascii" then
    return forced
  end

  -- No chafa or no asset means nothing to render the image from.
  if vim.fn.executable("chafa") ~= 1 or not vim.uv.fs_stat(LOGO_PNG) then
    return "ascii"
  end

  -- A multiplexer that does not carry graphics escapes renders them as litter.
  if in_blind_multiplexer() then
    return "ascii"
  end

  -- herdr speaks the Kitty graphics protocol itself, so a herdr pane counts as
  -- capable even though TERM inside one degrades to xterm-256color.
  if has_env_prefix("HERDR_") then
    return "kitty"
  end

  local prog = (vim.env.TERM_PROGRAM or ""):lower()
  local term = (vim.env.TERM or ""):lower()
  local kitty_capable = prog:find("ghostty", 1, true)
    or prog:find("kitty", 1, true)
    or term:find("ghostty", 1, true)
    or term:find("kitty", 1, true)
    or vim.env.KITTY_WINDOW_ID ~= nil

  return kitty_capable and "kitty" or "symbols"
end

local function logo_section()
  local tier = logo_tier()

  -- The ascii tier goes through preset.header, which snacks centres for us.
  -- `text` would need Text chunk tables rather than plain strings.
  if tier == "ascii" then
    return { section = "header", padding = 1 }
  end

  -- --size is in character cells. The mark is square and cells are roughly
  -- 1:2, so width is double the height. The sleep lets chafa's output flush
  -- before the terminal section is captured.
  local cmd = table.concat({
    "chafa",
    vim.fn.shellescape(LOGO_PNG),
    "--format kitty",
    ("--size %dx%d"):format(LOGO_WIDTH, LOGO_HEIGHT),
    "--clear",
    "; sleep .1",
  }, " ")

  return {
    section = "terminal",
    cmd = cmd,
    height = LOGO_HEIGHT,
    width = LOGO_WIDTH,
    align = "center",
    padding = 1,
    -- Nothing in a static logo justifies re-running chafa on every open
    ttl = 60 * 60 * 24,
  }
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Only these two. snacks is a bundle and the rest stays off on purpose;
      -- see docs/TRIAGE.md.
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

      -- Report which tier was picked, so a silent downgrade is debuggable.
      vim.api.nvim_create_user_command("DashboardLogoTier", function()
        vim.notify("dashboard logo tier: " .. logo_tier(), vim.log.levels.INFO)
      end, { desc = "Which logo rendering tier the dashboard chose" })
    end,
  },
}
