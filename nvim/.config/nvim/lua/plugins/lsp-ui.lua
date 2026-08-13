-- LSP interaction UI: peeking at locations, and previewing code actions.
--
-- Neither of these replaces the native LSP; they replace the *presentation*.
-- Hover needs nothing here: `vim.o.winborder` gives it a rounded border and
-- render-markdown renders the float's markdown automatically through its default
-- `buftype.nofile` override.

return {
  -- Visible feedback while the language server is busy.
  --
  -- This is the answer to "did my keypress do anything". Measured on a 320
  -- reference TypeScript project: the references *request* is 28ms warm and
  -- 119ms cold, so it needs no spinner. The multi-second wait is tsserver
  -- indexing, and vtsls does emit $/progress for that phase ("Analyzing
  -- 'util.ts' and its dependencies", "Initializing tsconfig.json"). fidget
  -- surfaces exactly those.
  --
  -- Bottom right; snacks.notifier was moved to the top right so they do not
  -- overlap, since both default to the same corner.
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        poll_rate = 0,
        display = {
          done_icon = "",
          done_style = "Comment",
          progress_style = "Comment",
          group_style = "Title",
          progress_icon = { pattern = "dots", period = 1 },
        },
      },
      notification = {
        poll_rate = 10,
        window = {
          winblend = 0, -- opaque, matching the telescope panes
          border = "rounded",
          relative = "editor",
          align = "bottom",
          x_padding = 1,
        },
      },
    },
  },

  -- Peek a definition or reference in a side window instead of jumping away and
  -- losing your place. This is the capability the old lspsaga config had on `gp`.
  {
    "DNLHC/glance.nvim",
    cmd = "Glance",
    keys = {
      -- Deliberately not `gr`: on 0.11+ that is the prefix for the native
      -- grn / gra / grr / gri / grt / grx mappings, and taking it would either
      -- shadow them or make every one of them wait for a timeout.
      { "gp", "<cmd>Glance definitions<cr>", desc = "Peek definitions" },
      { "gP", "<cmd>Glance type_definitions<cr>", desc = "Peek type definitions" },
      { "gR", "<cmd>Glance references<cr>", desc = "Peek references" },
      { "gM", "<cmd>Glance implementations<cr>", desc = "Peek implementations" },
    },
    opts = function()
      local actions = require("glance").actions
      return {
        height = 20,
        -- Keeps the parent window's context visible behind the preview
        preserve_win_context = true,
        -- Float above everything when the window is too narrow to embed in
        detached = function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end,
        preview_win_opts = { cursorline = true, number = true, wrap = false },
        border = { enable = true, top_char = "─", bottom_char = "─" },
        list = { position = "right", width = 0.33 },
        -- Derive colours from gruvbox rather than hardcoding a second palette
        theme = { enable = true, mode = "auto" },
        mappings = {
          list = {
            ["j"] = actions.next,
            ["k"] = actions.previous,
            ["<Down>"] = actions.next,
            ["<Up>"] = actions.previous,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["<C-u>"] = actions.preview_scroll_win(5),
            ["<C-d>"] = actions.preview_scroll_win(-5),
            ["v"] = actions.jump_vsplit,
            ["s"] = actions.jump_split,
            ["t"] = actions.jump_tab,
            ["<CR>"] = actions.jump,
            ["l"] = actions.enter_win("preview"),
            -- q and Esc close, matching every other transient window here
            ["q"] = actions.close,
            ["<Esc>"] = actions.close,
          },
          preview = {
            ["q"] = actions.close,
            ["<Esc>"] = actions.close,
            ["<Tab>"] = actions.next_location,
            ["<S-Tab>"] = actions.previous_location,
            ["h"] = actions.enter_win("list"),
          },
        },
      }
    end,
  },

  -- Code actions with a diff of what each one would actually do, rather than a
  -- numbered list of vague titles. This owns <leader>ca; lsp.lua deliberately
  -- does not map it, because a buffer-local mapping there would win over this.
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    event = "LspAttach",
    keys = {
      {
        "<leader>ca",
        function()
          require("tiny-code-action").code_action()
        end,
        mode = { "n", "v" },
        desc = "Code action (with diff preview)",
      },
    },
    opts = {
      -- delta is installed and gives a syntax-highlighted diff. Upstream warns
      -- it can be slow on very large actions; switch to "vim" if a big
      -- organise-imports ever feels sluggish.
      backend = "delta",
      -- telescope, so this inherits the borders and highlights set in
      -- plugins/telescope.lua
      picker = "telescope",
      backend_opts = {
        delta = {
          header_lines_to_remove = 4,
          args = { "--line-numbers" },
        },
      },
    },
  },
}
