return {
  -- ============================================================================
  -- THEMES (switch with <leader>uC)
  -- ============================================================================

  -- One Dark Pro - Atom's iconic theme (default)
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = "italic",
        keywords = "italic",
        conditionals = "italic",
      },
      options = {
        cursorline = true,
        transparency = true,
        terminal_colors = true,
        highlight_inactive_windows = false,
      },
    },
  },

  -- Catppuccin - best plugin integration, 4 flavors
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "italic" },
      },
      integrations = {
        blink_cmp = true,
        dashboard = true,
        dropbar = { enabled = true, color_mode = true },
        gitsigns = true,
        harpoon = true,
        indent_blankline = { enabled = true, scope_color = "lavender" },
        lsp_trouble = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true, underlines = { errors = { "undercurl" } } },
        neotree = true,
        noice = true,
        notify = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
  },

  -- TokyoNight - clean dark theme by Folke
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- night, storm, day, moon
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      sidebars = { "qf", "help", "neo-tree", "terminal", "Trouble" },
      on_highlights = function(hl, c)
        -- Transparent cursorline (just underline current line number)
        hl.CursorLine = { bg = "NONE" }
        hl.CursorLineNr = { fg = c.blue, bold = true }
        -- Transparent statusline
        hl.StatusLine = { fg = c.fg, bg = "NONE" }
        hl.StatusLineNC = { fg = c.comment, bg = "NONE" }
      end,
    },
  },

  -- Kanagawa - inspired by Hokusai painting
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "wave", -- wave, dragon, lotus
      transparent = true,
      terminalColors = true,
      colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
    },
  },

  -- Rose Pine - soho vibes
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main", -- main, moon, dawn
      dark_variant = "main",
      styles = { italic = true, transparency = true },
    },
  },

  -- Nightfox - highly customizable
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = true,
        styles = { comments = "italic", keywords = "italic" },
      },
    },
  },

  -- Configure LazyVim colorscheme (default to tokyonight)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- ============================================================================
  -- SNACKS.NVIM - Folke's QoL collection (replaces notify, indent-blankline)
  -- ============================================================================

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Animations for UI elements
      animate = { enabled = true },
      -- Better vim.ui.input
      input = { enabled = true },
      -- Notifications (replaces nvim-notify)
      notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
      },
      -- Indent guides (replaces indent-blankline)
      indent = {
        enabled = true,
        char = "│",
        scope = { enabled = true },
      },
      -- Smooth scrolling
      scroll = {
        enabled = true,
        animate = { duration = { step = 15, total = 150 } },
      },
      -- Scope dimming (focus on current scope)
      dim = { enabled = true },
      -- Zen mode
      zen = { enabled = true },
      -- Quick file loading
      quickfile = { enabled = true },
      -- Status column
      statuscolumn = { enabled = true },
      -- Words highlighting (LSP references)
      words = { enabled = true },
      -- Dashboard disabled (using custom dashboard-nvim)
      dashboard = { enabled = false },
    },
    keys = {
      { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Zen Zoom" },
      { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>uD", function() Snacks.dim() end, desc = "Toggle Dim" },
    },
  },

  -- Disable nvim-notify (snacks.notifier replaces it)
  { "rcarriga/nvim-notify", enabled = false },

  -- Disable indent-blankline (snacks.indent replaces it)
  { "lukas-reineke/indent-blankline.nvim", enabled = false },

  -- ============================================================================
  -- NOICE.NVIM - Cmdline, messages, popupmenu replacement
  -- ============================================================================

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
        },
      },
      messages = { enabled = true, view = "notify" },
      popupmenu = { enabled = true, backend = "nui" },
      notify = { enabled = true },
      lsp = {
        progress = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true },
        signature = { enabled = true },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        -- Hide "written" messages
        { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        -- Hide search count messages
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    },
  },

  -- ============================================================================
  -- ANIMATIONS
  -- ============================================================================

  -- Smear cursor - Neovide-like cursor trail
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
    },
  },

  -- Reactive - mode-aware highlights
  {
    "rasulomaroff/reactive.nvim",
    event = "VeryLazy",
    opts = {
      builtin = {
        cursorline = true,
        cursor = true,
        modemsg = true,
      },
    },
  },

  -- ============================================================================
  -- CORE UI
  -- ============================================================================

  -- Better buffer line (tabs)
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "buffers",
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Lualine status line (simplified - dropbar shows path)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
        theme = {
          normal = {
            a = { fg = "#7aa2f7", bg = "NONE" },
            b = { fg = "#c0caf5", bg = "NONE" },
            c = { fg = "#565f89", bg = "NONE" },
          },
          insert = { a = { fg = "#9ece6a", bg = "NONE" } },
          visual = { a = { fg = "#bb9af7", bg = "NONE" } },
          replace = { a = { fg = "#f7768e", bg = "NONE" } },
          command = { a = { fg = "#e0af68", bg = "NONE" } },
          inactive = {
            a = { fg = "#565f89", bg = "NONE" },
            b = { fg = "#565f89", bg = "NONE" },
            c = { fg = "#565f89", bg = "NONE" },
          },
        },
      })
      opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
        -- Remove filename since dropbar already shows full path
        lualine_c = {
          { "diagnostics" },
        },
        lualine_z = {
          { "location", padding = { left = 1, right = 1 } },
        },
      })
      return opts
    end,
  },

  -- Dropbar - IDE-like breadcrumb winbar
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>;", function() require("dropbar.api").pick() end, desc = "Dropbar pick" },
    },
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")
          if vim.bo[buf].ft == "markdown" then
            return { sources.markdown }
          end
          if vim.bo[buf].buftype == "terminal" then
            return { sources.terminal }
          end
          return {
            sources.path,
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },
    },
  },

  -- ============================================================================
  -- FOCUS & WINDOW MANAGEMENT
  -- ============================================================================

  -- Focus.nvim - auto-resize active window (golden ratio)
  {
    "nvim-focus/focus.nvim",
    event = "VeryLazy",
    opts = {
      enable = true,
      commands = true,
      autoresize = { enable = true },
      ui = {
        number = false,
        relativenumber = false,
        hybridnumber = false,
        signcolumn = true,
        cursorline = true,
      },
    },
    keys = {
      { "<leader>wf", "<cmd>FocusToggle<cr>", desc = "Toggle Focus Mode" },
    },
  },

  -- Incline - floating statuslines per window
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      hide = { cursorline = true },
      window = {
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.bo[props.buf].modified and " ●" or ""

        return {
          { (ft_icon or "") .. " ", guifg = ft_color },
          { filename .. modified, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
        }
      end,
    },
  },
}
