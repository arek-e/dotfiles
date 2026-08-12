return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local logo = [[
      ██╗  ██╗███████╗██╗     ██╗      ██████╗        █████╗ ██╗     ███████╗██╗  ██╗
      ██║  ██║██╔════╝██║     ██║     ██╔═══██╗      ██╔══██╗██║     ██╔════╝╚██╗██╔╝
      ███████║█████╗  ██║     ██║     ██║   ██║      ███████║██║     █████╗   ╚███╔╝
      ██╔══██║██╔══╝  ██║     ██║     ██║   ██║      ██╔══██║██║     ██╔══╝   ██╔██╗
      ██║  ██║███████╗███████╗███████╗╚██████╔╝▄█╗   ██║  ██║███████╗███████╗██╔╝ ██╗
      ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
      ]]

      logo = string.rep("\n", 2) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            { action = function() require("telescope.builtin").find_files() end, desc = " Find File    ", icon = "  ", key = "f", key_hl = "DashboardKey" },
            { action = "ene | startinsert", desc = " New File     ", icon = "  ", key = "n", key_hl = "DashboardKey" },
            { action = function() require("telescope.builtin").oldfiles() end, desc = " Recent Files ", icon = "  ", key = "r", key_hl = "DashboardKey" },
            { action = function() require("persistence").load() end, desc = " Restore Session", icon = "  ", key = "s", key_hl = "DashboardKey" },
            { action = function() require("telescope.builtin").live_grep() end, desc = " Find Text    ", icon = "  ", key = "g", key_hl = "DashboardKey" },
            { action = function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end, desc = " Config       ", icon = "  ", key = "c", key_hl = "DashboardKey" },
            { action = "Lazy", desc = " Plugins      ", icon = " 󰒲 ", key = "l", key_hl = "DashboardKey" },
            { action = "qa", desc = " Quit         ", icon = "  ", key = "q", key_hl = "DashboardKey" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "", string.format("  %d/%d plugins in %sms", stats.loaded, stats.count, ms) }
          end,
        },
      }

      -- Close lazy and re-open when dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },

  -- Disable LazyVim's default dashboard (snacks)
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },
}
