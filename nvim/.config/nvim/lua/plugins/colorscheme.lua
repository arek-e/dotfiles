-- Exactly one colorscheme. Matches the Ghostty and herdr gruvbox theme.

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- must load before any UI is drawn
    priority = 1000, -- and before every other plugin
    opts = {
      terminal_colors = true,
      contrast = "hard", -- "hard" | "" | "soft"
      transparent_mode = true, -- config.autocmds also enforces this
      italic = {
        strings = false, -- italic strings age badly in most terminal fonts
        comments = true,
        keywords = true,
        folds = true,
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
