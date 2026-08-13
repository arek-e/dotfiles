-- Keymap discovery. Earns its place while the config is being rebuilt: it is
-- how you find out what is actually bound after each plugin gets added back.

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      -- Open immediately on <leader> rather than waiting out timeoutlen. The
      -- point of which-key here is discovery, and a 300ms pause is long enough
      -- that you start typing before it appears and never see it.
      delay = 0,
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunk" },
        { "<leader>s", group = "search" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>p", group = "project" },
        { "<leader>q", group = "session" },
        { "<leader>u", group = "ui/toggles" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer keymaps",
      },
    },
  },
}
