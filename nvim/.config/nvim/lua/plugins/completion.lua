-- Completion.
--
-- blink.cmp rather than nvim-cmp: one plugin instead of a stack of
-- cmp-* source adapters, and it ships a prebuilt fuzzy matcher.
-- `version = "*"` pulls a release tag, which is what downloads the prebuilt
-- binary; tracking main would require a Rust toolchain to build it.

return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        -- 'default' is C-y to accept, C-n/C-p to cycle, which leaves Tab
        -- free for snippet jumps and indentation.
        preset = "default",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = "rounded",
          draw = { treesitter = { "lsp" } },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = false },
      },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      -- Rust matcher; falls back to the Lua one if the binary is missing
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
