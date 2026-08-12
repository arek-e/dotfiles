-- Diagnostic presentation.
--
-- tiny-inline-diagnostic replaces Neovim's own virtual_text. The built-in
-- version appends the whole message to the end of the line, which wraps badly
-- and collides with code; this renders a boxed, wrapped, severity-coloured
-- message instead, and only for the line the cursor is on.
--
-- `virtual_text = false` is set in lua/plugins/lsp.lua rather than here, so that
-- all diagnostic display settings stay in one place. Leaving it on would draw
-- both, one on top of the other.

return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000, -- ahead of anything else that touches diagnostics
    opts = {
      preset = "modern",
      options = {
        -- Show the source (eslint, vtsls) when more than one server reports
        show_source = { enabled = true, if_many = true },
        -- Make file paths in messages relative and clickable-ish
        use_icons_from_diagnostic = false,
        -- Put the message under the line when it would otherwise run off the
        -- right edge, which happens a lot with TypeScript's longer errors.
        overflow = { mode = "wrap" },
        -- Only the cursor's line, otherwise it is as noisy as virtual_text was
        multilines = { enabled = false },
        show_all_diags_on_cursorline = false,
        -- Do not fight the LSP progress messages during startup
        throttle = 20,
      },
    },
  },
}
