return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical Terminal" },
      -- Numbered terminals
      { "<leader>t1", "<cmd>1ToggleTerm direction=float<cr>", desc = "Terminal 1" },
      { "<leader>t2", "<cmd>2ToggleTerm direction=float<cr>", desc = "Terminal 2" },
      { "<leader>t3", "<cmd>3ToggleTerm direction=float<cr>", desc = "Terminal 3" },
      -- Swap: hide terminal, show Claude
      {
        "<leader>ta",
        function()
          -- Hide terminal
          require("toggleterm").toggle(1, nil, nil, "float")
          -- Show Claude
          vim.defer_fn(function()
            vim.cmd("ClaudeCode")
          end, 50)
        end,
        desc = "Terminal -> Claude",
      },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return 80
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      float_opts = {
        border = "rounded",
        width = function() return math.floor(vim.o.columns * 0.85) end,
        height = function() return math.floor(vim.o.lines * 0.85) end,
      },
    },
  },
}
