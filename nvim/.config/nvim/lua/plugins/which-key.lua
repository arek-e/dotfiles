-- Keymap discovery. Earns its place while the config is being rebuilt: it is
-- how you find out what is actually bound after each plugin gets added back.

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300, -- matches timeoutlen
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>s", group = "search" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>p", group = "project" },
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
