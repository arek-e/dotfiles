return {
  -- Show dotfiles (.env, .env.local, etc.) in neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      need = 1,
      branch = true,
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Harpoon - quick file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local harpoon = require("harpoon")
      return {
        {
          "<leader>A",
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
      -- Git status (modified files)
      {
        "<leader>gs",
        function()
          require("telescope.builtin").git_status()
        end,
        desc = "Git Status (modified files)",
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
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
        sorting_strategy = "ascending",
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
          ".vercel/",
          ".svelte%-kit/",
          ".cache/",
          "coverage/",
          ".output/",
          "*.min.js",
          "*.min.css",
          "package%-lock.json",
          "yarn.lock",
          "pnpm%-lock.yaml",
        },
      })
      return opts
    end,
  },

  -- Disable Trouble (replaced by lspsaga)
  { "folke/trouble.nvim", enabled = false },

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

  -- ============================================================================
  -- EDITING ENHANCEMENTS
  -- ============================================================================

  -- TreeSJ - split/join code blocks with treesitter
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>j", "<cmd>TSJToggle<cr>", desc = "Toggle Split/Join" },
      { "<leader>cJ", "<cmd>TSJSplit<cr>", desc = "Split Code Block" },
      { "<leader>cj", "<cmd>TSJJoin<cr>", desc = "Join Code Block" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
  },

  -- Dial - enhanced increment/decrement
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      { "g<C-a>", function() return require("dial.map").inc_gnormal() end, expr = true, desc = "Increment (additive)" },
      { "g<C-x>", function() return require("dial.map").dec_gnormal() end, expr = true, desc = "Decrement (additive)" },
      { "<C-a>", function() return require("dial.map").inc_visual() end, mode = "v", expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_visual() end, mode = "v", expr = true, desc = "Decrement" },
      { "g<C-a>", function() return require("dial.map").inc_gvisual() end, mode = "v", expr = true, desc = "Increment (additive)" },
      { "g<C-x>", function() return require("dial.map").dec_gvisual() end, mode = "v", expr = true, desc = "Decrement (additive)" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "true", "false" } }),
          augend.constant.new({ elements = { "True", "False" } }),
          augend.constant.new({ elements = { "yes", "no" } }),
          augend.constant.new({ elements = { "on", "off" } }),
          augend.constant.new({ elements = { "left", "right" } }),
          augend.constant.new({ elements = { "up", "down" } }),
          augend.constant.new({ elements = { "enable", "disable" } }),
          augend.constant.new({ elements = { "enabled", "disabled" } }),
          augend.constant.new({ elements = { "public", "private", "protected" } }),
          augend.constant.new({ elements = { "&&", "||" }, word = false }),
          augend.constant.new({ elements = { "let", "const" } }),
          augend.semver.alias.semver,
        },
      })
    end,
  },

  -- Spider - better word motions (respects camelCase)
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider w" },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider e" },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider b" },
    },
    opts = {
      skipInsignificantPunctuation = true,
    },
  },

  -- Todo Comments - highlight and search TODOs
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search Todos" },
    },
  },

  -- UFO - modern code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function(_, filetype, buftype)
        if buftype == "nofile" then
          return ""
        end
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with" },
    },
  },

  -- ============================================================================
  -- SEARCH & REPLACE
  -- ============================================================================

  -- Grug-far - search and replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>sr", function() require("grug-far").open({ transient = true }) end, desc = "Search & Replace (Grug-far)" },
      { "<leader>sR", function() require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } }) end, desc = "Search & Replace (current file)" },
      { "<leader>sw", function() require("grug-far").open({ transient = true, prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Search word under cursor" },
      { "<leader>sr", function()
        require("grug-far").open({
          transient = true,
          prefills = { search = vim.fn.getreg("v") },
        })
      end, mode = "v", desc = "Search selection" },
    },
    opts = {
      headerMaxWidth = 80,
      icons = {
        enabled = true,
      },
      keymaps = {
        replace = { n = "<localleader>r" },
        qflist = { n = "<localleader>q" },
        syncLocations = { n = "<localleader>s" },
        syncLine = { n = "<localleader>l" },
        close = { n = "<localleader>c" },
        historyOpen = { n = "<localleader>t" },
        historyAdd = { n = "<localleader>a" },
        refresh = { n = "<localleader>f" },
        openLocation = { n = "<localleader>o" },
        abort = { n = "<localleader>b" },
        toggleShowCommand = { n = "<localleader>p" },
        swapEngine = { n = "<localleader>e" },
      },
    },
  },

  -- ============================================================================
  -- TASK RUNNER
  -- ============================================================================

  -- Overseer - task runner and job management
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerOpen",
      "OverseerClose",
      "OverseerBuild",
      "OverseerTaskAction",
      "OverseerQuickAction",
    },
    keys = {
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build" },
    },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 15,
        max_height = 25,
        default_detail = 1,
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-l>"] = "IncreaseDetail",
          ["<C-h>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
          ["q"] = "Close",
        },
      },
      templates = { "builtin" },
      strategy = {
        "toggleterm",
        direction = "horizontal",
        highlights = nil,
        auto_scroll = true,
        close_on_exit = false,
        quit_on_exit = "never",
        open_on_start = true,
        hidden = false,
      },
    },
  },
}
