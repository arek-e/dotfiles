return {
  -- Claude Code integration - terminal with auto file reload
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>aC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Continue" },
      { "<leader>aR", "<cmd>ClaudeCodeResume<cr>", desc = "Claude Resume (pick session)" },
    },
    opts = {
      window = {
        type = "float",
        position = "center",
        width = 0.85,
        height = 0.85,
        border = "rounded",
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
