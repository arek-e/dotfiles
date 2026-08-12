-- Window layout: pin transient split windows to fixed screen edges.
--
-- Worth being clear about what this does and does not cover here. edgy manages
-- *split* windows only, so it never touches telescope, mini.files, Lazy or Mason
-- — those are all floats. With no persistent sidebar in this config, what it
-- actually earns you is that quickfix, location lists and help stop opening at
-- whatever size and position the last split happened to leave, and start
-- appearing in the same place every time.
--
-- `splitkeep` matters more than it looks: without it the main window's content
-- jumps every time an edgebar opens.

return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Toggle edgebars",
      },
      {
        "<leader>uE",
        function()
          require("edgy").select()
        end,
        desc = "Select edgebar window",
      },
    },
    init = function()
      -- Stops the main split's text jumping when an edgebar opens or closes.
      vim.opt.splitkeep = "screen"
      -- laststatus = 3 is already set in config/options.lua; edgy needs it for
      -- views to collapse fully.
    end,
    opts = {
      animate = { enabled = false }, -- matches snacks: no animation while working

      bottom = {
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 0.4 },
          -- Only once it is actually a help buffer, not while it is loading
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        -- :terminal splits, for the rare case one is used inside nvim rather
        -- than in a herdr pane.
        { ft = "terminal", size = { height = 0.3 } },
      },

      right = {
        -- Nothing pinned by default: there is no sidebar in this config. Left
        -- declared so the edge exists if something is added later.
      },

      options = {
        bottom = { size = 12 },
        right = { size = 40 },
      },

      -- Do not keep an empty edgebar hanging around
      close_when_all_hidden = true,
      exit_when_last = false,

      wo = {
        winbar = true,
        winfixwidth = false,
        winfixheight = true,
      },
    },
  },
}
