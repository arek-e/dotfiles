-- Autopairs.
--
-- mini.pairs rather than nvim-autopairs, to stay in the mini ecosystem already
-- used for the explorer and icons. Smaller surface, same conventions: it is
-- "pair these characters in these neighbourhoods" and nothing else. It
-- deliberately has no bracket-balance smartness.
--
-- blink.cmp's `auto_brackets` already adds `()` when you accept a function
-- completion; this covers brackets and quotes typed by hand.

return {
  {
    "nvim-mini/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {
      modes = { insert = true, command = false, terminal = false },

      -- `neigh_pattern` matches the two characters around the cursor, where
      -- `\r` is line start and `\n` is line end.
      --
      -- The defaults only guard the left side (`^[^\\]`, i.e. not after a
      -- backslash). These add a right-side guard of `[^%w]`, so an opening
      -- character typed immediately before a word does not pair: typing `(` in
      -- front of `foo` gives `(foo` rather than `()foo`, which is the single
      -- most irritating autopairs behaviour. `\n` is not a word character, so
      -- pairing still happens at end of line, which is the common case.
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%w]" },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%w]" },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%w]" },

        -- Closing characters keep the defaults: typing `)` over an existing `)`
        -- should always step over it.
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        -- `'` also avoids pairing after a letter, so don't/isn't stay intact.
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\][^%w]", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\][^%w]", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\][^%w]", register = { cr = false } },
      },
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)

      -- Off in prompt-style buffers, where a stray closing character is pure
      -- friction. mini.pairs reads this buffer variable on every keypress.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_pairs_disable", { clear = true }),
        pattern = { "TelescopePrompt", "snacks_dashboard", "snacks_input", "minifiles" },
        callback = function(event)
          vim.b[event.buf].minipairs_disable = true
        end,
      })
    end,
  },
}
