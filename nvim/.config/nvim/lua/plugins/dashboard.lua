-- Start page.
--
-- The header is the Legora mark, drawn with braille subpixels: a square with a
-- 90-degree arc carved out of three corners and a square notch in the fourth
-- (top right). Generated rather than hand-drawn, at 2x4 subpixels per cell,
-- which is what makes the concave arcs read as curves.
--
-- Every line is padded to the same width on purpose. dashboard-nvim centres
-- each header line independently, so unequal widths would shear the asymmetric
-- notch out of alignment.

local logo = {
  "                  ⢠                 ",
  "                  ⣸                 ",
  "                 ⢠⣿                 ",
  "                ⢠⣿⣿                 ",
  "               ⣠⣿⣿⣿                 ",
  "             ⢀⣴⣿⣿⣿⣿                 ",
  "           ⢀⣴⣿⣿⣿⣿⣿⣿                 ",
  "        ⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿                 ",
  "⣀⣀⣀⣀⣠⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                 ",
  "⠉⠉⠉⠉⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠋⠉⠉",
  "        ⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠉      ",
  "           ⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁         ",
  "             ⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁           ",
  "               ⠙⣿⣿⣿⣿⣿⣿⠋             ",
  "                ⠘⣿⣿⣿⣿⠃              ",
  "                 ⠘⣿⣿⠃               ",
  "                  ⢹⡏                ",
  "                  ⠘⠃                ",
}

return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local header = { "" }
      vim.list_extend(header, logo)
      vim.list_extend(header, { "", "" })

      return {
        theme = "doom",
        hide = { statusline = false },
        config = {
          header = header,
          center = {
            {
              action = "Telescope find_files",
              desc = " Find file",
              icon = "  ",
              key = "f",
            },
            {
              action = "ene | startinsert",
              desc = " New file",
              icon = "  ",
              key = "n",
            },
            {
              action = "Telescope oldfiles",
              desc = " Recent files",
              icon = "  ",
              key = "r",
            },
            {
              action = "Telescope live_grep",
              desc = " Find text",
              icon = "  ",
              key = "g",
            },
            {
              action = function()
                require("mini.files").open(vim.uv.cwd(), true)
              end,
              desc = " Explorer",
              icon = "  ",
              key = "e",
            },
            {
              action = function()
                vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
              end,
              desc = " Config",
              icon = "  ",
              key = "c",
            },
            {
              action = "Lazy",
              desc = " Plugins",
              icon = " 󰒲 ",
              key = "l",
            },
            {
              action = "Mason",
              desc = " Language servers",
              icon = "  ",
              key = "m",
            },
            {
              action = "qa",
              desc = " Quit",
              icon = "  ",
              key = "q",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
            return {
              "",
              ("%d/%d plugins loaded in %s ms"):format(stats.loaded, stats.count, ms),
            }
          end,
        },
      }
    end,
    config = function(_, opts)
      -- Pad the desc column so the icon/key columns line up
      for _, item in ipairs(opts.config.center) do
        item.desc = item.desc .. string.rep(" ", 43 - #item.desc)
        item.key_format = "  %s"
      end

      -- The mark in a green that survives a dark background. The brand green is
      -- far too dark to read here, so this is gruvbox's green standing in.
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#689d6a" })
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#928374", italic = true })

      require("dashboard").setup(opts)
    end,
  },
}
