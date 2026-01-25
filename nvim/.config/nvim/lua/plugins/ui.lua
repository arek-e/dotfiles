return {
  -- Tokyonight theme with customization
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- night, storm, day, moon
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "neo-tree", "terminal", "Trouble" },
      on_highlights = function(hl, c)
        -- Make the cursor line more visible
        hl.CursorLine = { bg = c.bg_highlight }
        -- Better diff colors
        hl.DiffAdd = { bg = "#1a3a1a" }
        hl.DiffChange = { bg = "#1a2a3a" }
        hl.DiffDelete = { bg = "#3a1a1a" }
        -- Dashboard colors
        hl.DashboardHeader = { fg = c.purple }
        hl.DashboardCenter = { fg = c.cyan }
        hl.DashboardFooter = { fg = c.comment }
        hl.DashboardShortCut = { fg = c.orange }
        hl.DashboardKey = { fg = c.green }
        hl.DashboardDesc = { fg = c.blue }
        hl.DashboardIcon = { fg = c.cyan }
      end,
    },
  },

  -- Configure LazyVim to use tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "compact",
      stages = "fade",
    },
  },

  -- Indent guides (v3 uses "ibl" module)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },

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

  -- Lualine status line
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = vim.tbl_deep_extend("force", opts.sections or {}, {
        lualine_z = {
          { "location", padding = { left = 1, right = 1 } },
        },
      })
      return opts
    end,
  },
}
