-- Start page.
--
-- The header is the Legora mark: a square with a 90-degree arc carved out of
-- three corners and a square notch in the fourth (top right). Generated from
-- that geometry rather than hand-drawn, then rendered with half blocks so the
-- concave arcs survive at this size.
--
-- Every line is padded to the same width on purpose: dashboard-nvim centres
-- each header line independently, so unequal widths would shear the
-- asymmetric notch out of alignment.

local logo = {
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
            { action = "Telescope find_files", desc = " Find file", icon = "  ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = "  ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = "  ", key = "r" },
            { action = "Telescope live_grep", desc = " Find text", icon = "  ", key = "g" },
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
            { action = "Lazy", desc = " Plugins", icon = " 󰞲 ", key = "l" },
            { action = "Mason", desc = " Language servers", icon = "  ", key = "m" },
            { action = "qa", desc = " Quit", icon = "  ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
            return { "", stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. " ms" }
          end,
        },
      }
    end,
    config = function(_, opts)
      for _, item in ipairs(opts.config.center) do
        item.desc = item.desc .. string.rep(" ", math.max(0, 43 - #item.desc))
        item.key_format = "  %s"
      end

      -- The mark in green. The brand forest green (~#0b5033) is far too dark to
      -- read on a dark background, so this is a lifted version of it. Change
      -- this one value to retint the mark.
      vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#2f9e63" })
      vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "DashboardKey", { fg = "#fabd2f" })
      vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#83a598" })
      vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#928374", italic = true })

      require("dashboard").setup(opts)
    end,
  },
}
