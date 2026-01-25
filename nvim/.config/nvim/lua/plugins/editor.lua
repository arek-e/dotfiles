return {
  -- Harpoon - quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local harpoon = require("harpoon")
      return {
        {
          "<leader>a",
          function()
            harpoon:list():add()
          end,
          desc = "Harpoon Add File",
        },
        {
          "<leader>h",
          function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Menu",
        },
        {
          "<leader>1",
          function()
            harpoon:list():select(1)
          end,
          desc = "Harpoon File 1",
        },
        {
          "<leader>2",
          function()
            harpoon:list():select(2)
          end,
          desc = "Harpoon File 2",
        },
        {
          "<leader>3",
          function()
            harpoon:list():select(3)
          end,
          desc = "Harpoon File 3",
        },
        {
          "<leader>4",
          function()
            harpoon:list():select(4)
          end,
          desc = "Harpoon File 4",
        },
        {
          "<leader>5",
          function()
            harpoon:list():select(5)
          end,
          desc = "Harpoon File 5",
        },
        {
          "[H",
          function()
            harpoon:list():prev()
          end,
          desc = "Harpoon Prev",
        },
        {
          "]H",
          function()
            harpoon:list():next()
          end,
          desc = "Harpoon Next",
        },
      }
    end,
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },
  },

  -- Oil - file explorer as a buffer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
      { "<leader>o", "<cmd>Oil<cr>", desc = "Oil File Explorer" },
    },
    opts = {
      default_file_explorer = false, -- neo-tree is still default, use - to access oil
      columns = {
        "icon",
        "size",
        "mtime",
      },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
      },
      float = {
        padding = 2,
        max_width = 120,
        max_height = 40,
        border = "rounded",
      },
    },
  },

  -- Telescope extensions
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      -- Find files at current file's directory
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find Files (current dir)",
      },
      -- Grep in current file's directory
      {
        "<leader>sG",
        function()
          require("telescope.builtin").live_grep({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Grep (current dir)",
      },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          ".next/",
          ".turbo/",
        },
      })
      return opts
    end,
  },

  -- Better quickfix
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },

  -- Better quickfix window with preview
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = "rounded",
        show_title = true,
        should_preview_cb = function(bufnr)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            ret = false
          elseif bufname:match("^fugitive://") then
            ret = false
          end
          return ret
        end,
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-v"] = "vsplit" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
  },
}
