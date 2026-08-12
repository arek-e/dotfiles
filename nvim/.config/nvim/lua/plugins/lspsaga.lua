return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- Breadcrumbs (replaces incline.nvim)
      symbol_in_winbar = {
        enable = true,
        separator = " > ",
        hide_keyword = true,
        show_file = true,
        folder_level = 1,
      },
      -- Lightbulb
      lightbulb = {
        enable = true,
        sign = true,
        virtual_text = false,
      },
      -- Finder
      finder = {
        max_height = 0.5,
        left_width = 0.3,
        right_width = 0.5,
        keys = {
          toggle_or_open = "<CR>",
          vsplit = "v",
          split = "s",
          quit = "q",
        },
      },
      -- Peek definition
      definition = {
        width = 0.6,
        height = 0.5,
      },
      -- Rename
      rename = {
        in_select = false,
        auto_save = true,
        keys = {
          quit = "<Esc>",
          exec = "<CR>",
        },
      },
      -- Code action
      code_action = {
        show_server_name = true,
        extend_gitsigns = true,
        keys = {
          quit = "q",
          exec = "<CR>",
        },
      },
      -- Diagnostics (replaces Trouble)
      diagnostic = {
        show_code_action = true,
        show_layout = "float",
        jump_num_shortcut = true,
        keys = {
          exec_action = "<CR>",
          quit = "q",
        },
      },
      -- Hover
      hover = {
        max_width = 0.6,
        max_height = 0.5,
        open_link = "gx",
      },
      -- Outline (replaces Trouble symbols)
      outline = {
        win_position = "right",
        win_width = 30,
        auto_preview = true,
        keys = {
          toggle_or_jump = "<CR>",
          quit = "q",
        },
      },
      -- Call hierarchy
      callhierarchy = {
        keys = {
          toggle_or_req = "<CR>",
          edit = "e",
          vsplit = "v",
          split = "s",
          quit = "q",
        },
      },
      -- Implement
      implement = {
        enable = true,
        sign = true,
        virtual_text = false,
      },
      -- Float terminal disabled (claude-code.nvim handles this)
      floaterm = {
        height = 0.7,
        width = 0.7,
      },
      -- UI
      ui = {
        border = "rounded",
        code_action = "💡",
      },
    },
    keys = {
      -- Finder
      { "gf", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
      -- Peek definition / type definition
      { "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
      { "gP", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek Type Definition" },
      -- Go to definition / type definition
      { "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Go to Definition" },
      { "gD", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Go to Type Definition" },
      -- Hover
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
      -- Code action
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", mode = { "n", "v" }, desc = "Code Action" },
      -- Rename
      { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
      { "<leader>cR", "<cmd>Lspsaga rename ++project<cr>", desc = "Rename (project-wide)" },
      -- Diagnostics
      { "<leader>xx", "<cmd>Lspsaga show_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xX", "<cmd>Lspsaga show_buf_diagnostics<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xl", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line Diagnostics" },
      { "<leader>xc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", desc = "Cursor Diagnostics" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Prev Diagnostic" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next Diagnostic" },
      -- Outline (replaces Trouble symbols)
      { "<leader>cs", "<cmd>Lspsaga outline<cr>", desc = "Symbol Outline" },
      -- Call hierarchy
      { "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>", desc = "Incoming Calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Outgoing Calls" },
    },
  },
}
