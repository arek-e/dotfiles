-- Fuzzy finder.
--
-- Telescope over snacks.picker: your muscle memory is already telescope, and
-- it stays a finder rather than arriving as part of a larger QoL bundle.
-- fzf-native is a compiled sorter; it needs `make` and a C compiler.
--
-- LOOK
--
-- Rounded borders in gruvbox orange (#fe8019, the palette's accent), with each
-- pane on its own background so the prompt, results and preview still read as
-- distinct blocks. Titles are coloured pills.
--
-- These panes are deliberately opaque even though the colorscheme runs in
-- transparent mode. A floating finder over a transparent background is hard to
-- read, because whatever is behind it shows through the results.
--
-- File icons come from mini.icons via its devicons shim, set up eagerly in
-- plugins/icons.lua. Without that loaded first, this list has no icons at all.

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        -- Skip the extension rather than error if the build did not run
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- Visual undo history, with a diff of each state
      "debugloop/telescope-undo.nvim",
      -- Ranks files by frequency + recency. No sqlite needed; uses fd/rg when
      -- present (both are) and falls back to Lua otherwise.
      "nvim-telescope/telescope-frecency.nvim",
      -- Yank history. Persistence would need kkharji/sqlite.lua and a sqlite
      -- lib, which is not installed, so this is session-scoped on purpose.
      {
        "AckslD/nvim-neoclip.lua",
        opts = {
          history = 200,
          enable_persistent_history = false,
          default_register = { '"', "+" },
          content_spec_column = true,
        },
      },
    },
    keys = {
      -- Files and buffers.
      -- Leader is Space, so <leader><leader> is the two-space chord. Written
      -- this way rather than <leader><space> because they are the same
      -- keystroke and this is how it is actually typed.
      { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find files (current dir)",
      },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },

      -- Grep
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
      {
        "<leader>sG",
        function()
          require("telescope.builtin").live_grep({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Grep (current dir)",
      },

      -- LSP pickers, which beat the raw quickfix list
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },

      -- Frecency: the "what do I actually open" list, ranked by frequency and
      -- recency rather than pure recency like oldfiles.
      { "<leader>fz", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Frecent files (cwd)" },
      { "<leader>fZ", "<cmd>Telescope frecency<cr>", desc = "Frecent files (all)" },

      -- Undo history and yank history
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history" },
      { "<leader>fy", "<cmd>Telescope neoclip<cr>", desc = "Yank history" },

      -- Meta
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          multi_icon = " ",
          sorting_strategy = "ascending",

          -- flex switches to a vertical stack on a narrow window instead of
          -- squeezing the preview into uselessness.
          layout_strategy = "flex",
          layout_config = {
            flex = { flip_columns = 140 },
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { prompt_position = "top", preview_height = 0.5, mirror = true },
            width = 0.88,
            height = 0.85,
            preview_cutoff = 20,
          },

          -- Order is { top, right, bottom, left, tl, tr, br, bl }.
          borderchars = {
            prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          },

          results_title = false, -- the results pane needs no label
          dynamic_preview_title = true, -- show the previewed file's name instead

          path_display = { filename_first = { reverse_directories = false } },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close, -- one keypress to leave, not two
            },
          },
          file_ignore_patterns = {
            "^.git/",
            "node_modules/",
            "dist/",
            "build/",
            "%.next/",
            "%.turbo/",
            "coverage/",
            "%.min%.js$",
            "%.min%.css$",
            "package%-lock%.json$",
            "yarn%.lock$",
            "pnpm%-lock%.yaml$",
          },
        },
        extensions = {
          undo = {
            -- Side-by-side diff of the undo state, rather than unified
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.7 },
            side_by_side = true,
            entry_format = "state #$ID, $STAT, $TIME",
          },
          frecency = {
            -- Show the path, not just the filename, and hide the score column
            show_scores = false,
            show_unindexed = true,
            disable_devicons = false,
            ignore_patterns = { "*/node_modules/*", "*/.git/*", "*/dist/*" },
          },
        },
        pickers = {
          -- Show dotfiles, which your old neo-tree config also did
          find_files = { hidden = true },
          buffers = {
            sort_mru = true,
            mappings = { i = { ["<C-d>"] = actions.delete_buffer } },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- pcall each: a missing or failed extension should not take telescope down
      for _, ext in ipairs({ "fzf", "undo", "frecency", "neoclip" }) do
        local ok, err = pcall(telescope.load_extension, ext)
        if not ok then
          vim.notify(("telescope: extension %q failed to load: %s"):format(ext, err), vim.log.levels.WARN)
        end
      end

      -- Gruvbox-dark values. Set from a ColorScheme autocmd so they survive a
      -- colorscheme reload, and applied once immediately for this session.
      local function highlights()
        local bg0, bg1, bg2 = "#282828", "#3c3836", "#504945"
        local dark = "#1d2021"
        local fg = "#ebdbb2"
        local orange, green, blue, grey = "#fe8019", "#b8bb26", "#83a598", "#928374"
        local set = function(group, val)
          vim.api.nvim_set_hl(0, group, val)
        end

        -- Prompt: lifted a step out of the results so it reads as an input.
        set("TelescopePromptNormal", { bg = bg1, fg = fg })
        set("TelescopePromptBorder", { bg = bg1, fg = orange })
        set("TelescopePromptTitle", { bg = orange, fg = dark, bold = true })
        set("TelescopePromptPrefix", { bg = bg1, fg = orange })
        set("TelescopePromptCounter", { bg = bg1, fg = grey })

        -- Results
        set("TelescopeNormal", { bg = bg0, fg = fg })
        set("TelescopeResultsNormal", { bg = bg0, fg = fg })
        set("TelescopeResultsBorder", { bg = bg0, fg = orange })
        set("TelescopeResultsTitle", { bg = bg0, fg = orange })
        set("TelescopeSelection", { bg = bg2, fg = fg, bold = true })
        set("TelescopeSelectionCaret", { bg = bg2, fg = orange, bold = true })
        set("TelescopeMultiSelection", { bg = bg2, fg = green })

        -- Preview: darkest pane, so the eye reads it as "behind" the list.
        set("TelescopePreviewNormal", { bg = dark })
        set("TelescopePreviewBorder", { bg = dark, fg = orange })
        set("TelescopePreviewTitle", { bg = green, fg = dark, bold = true })

        -- The matched characters in each entry
        set("TelescopeMatching", { fg = blue, bold = true })
      end

      highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("user_telescope_hl", { clear = true }),
        callback = highlights,
      })
    end,
  },
}
