return {
  -- Claude Code integration - terminal with auto file reload
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>aC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Continue" },
      { "<leader>aR", "<cmd>ClaudeCodeResume<cr>", desc = "Claude Resume (pick session)" },
    },
    opts = {
      window = {
        position = "float",
        float = {
          width = "85%",
          height = "85%",
          row = "center",
          col = "center",
          border = "rounded",
        },
      },
      refresh = {
        enable = true,
        updatetime = 100,
        timer_interval = 1000,
        show_notifications = true,
      },
      git = {
        use_git_root = true,
      },
    },
  },
}
