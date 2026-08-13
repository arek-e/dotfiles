-- Editing and navigation aids.

return {
  -- Highlight and search TODO / FIX / HACK / NOTE comments.
  --
  -- Uses ripgrep for the search, which is already installed. The telescope
  -- integration is why the search key sits under <leader>s with the other
  -- pickers rather than somewhere of its own.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous TODO",
      },
    },
    opts = {
      signs = true,
      -- Gruvbox-ish, matching the palettes used elsewhere in this config
      colors = {
        error = { "DiagnosticError", "#fb4934" },
        warning = { "DiagnosticWarn", "#fabd2f" },
        info = { "DiagnosticInfo", "#83a598" },
        hint = { "DiagnosticHint", "#b8bb26" },
        default = { "Identifier", "#d3869b" },
      },
      highlight = {
        -- Only the keyword gets a background; highlighting the whole line is
        -- noisy in a file with many notes.
        keyword = "wide_bg",
        after = "fg",
      },
    },
  },

  -- Jump anywhere on screen by typing the label next to the target.
  --
  -- NOTE ON KEYS: upstream's defaults take `s` and `S`, which are Vim's
  -- substitute-character and substitute-line. `cl` and `cc` do exactly the same
  -- thing, which is why nearly every flash config accepts the trade. If you miss
  -- them, delete those two entries and flash still improves `f`/`F`/`t`/`T`
  -- through its char mode, which needs no mapping at all.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- Labels appear on f/F/t/T without taking a key
      modes = {
        char = { enabled = true, jump_labels = true },
        -- Off: labelling every `/` match fights incsearch, and `s` covers it
        search = { enabled = false },
      },
      label = { rainbow = { enabled = false } },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter (select node)",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote flash (operate elsewhere)",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter search",
      },
      {
        "<c-s>",
        mode = "c",
        function()
          require("flash").toggle()
        end,
        desc = "Toggle flash while searching",
      },
    },
  },
}
