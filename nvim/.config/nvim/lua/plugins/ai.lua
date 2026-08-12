return {
  -- Disable avante
  { "yetone/avante.nvim", enabled = false },

  -- Claude Code
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>aa", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Continue" },
      { "<leader>ar", "<cmd>ClaudeCodeResume<cr>", desc = "Claude Resume" },
      {
        "<leader>al",
        function()
          local cc = require("claude-code")
          local cfg = cc.config or cc.opts
          if cfg and cfg.window then
            if cfg.window.position == "float" then
              cfg.window.position = "vertical"
              cfg.window.split_ratio = 0.35
              vim.notify("Claude: split right", vim.log.levels.INFO)
            else
              cfg.window.position = "float"
              vim.notify("Claude: float overlay", vim.log.levels.INFO)
            end
          end
        end,
        desc = "Claude Toggle Layout",
      },
      -- Swap: hide Claude, show terminal
      {
        "<leader>at",
        function()
          -- Hide Claude Code
          vim.cmd("ClaudeCode")
          -- Show terminal
          vim.defer_fn(function()
            require("toggleterm").toggle(1, nil, nil, "float")
          end, 50)
        end,
        desc = "Claude -> Terminal",
      },
    },
    opts = {
      command = "claude --dangerously-skip-permissions",
      window = {
        position = "float",
        split_ratio = 0.35,
        enter_insert = true,
        hide_numbers = true,
        hide_signcolumn = true,
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
      keymaps = {
        toggle = {
          normal = false,
          terminal = false,
          variants = {
            continue = "<leader>ac",
            resume = "<leader>ar",
          },
        },
        window_navigation = true,
        scrolling = true,
      },
    },
  },
}
