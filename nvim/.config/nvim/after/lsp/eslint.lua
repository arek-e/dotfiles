-- ESLint as a language server: diagnostics in the buffer plus a fix-all
-- command. This is why there is no separate nvim-lint plugin.
--
-- Only `settings` is overridden here. The fix-all-on-save autocmd lives in
-- lua/plugins/lsp.lua, because it has to wrap lspconfig's own `on_attach`
-- rather than replace it: config tables are merged with `force`, so defining
-- `on_attach` in this file would drop the LspEslintFixAll command it creates.

return {
  settings = {
    -- Resolve the ESLint config per package, which is what monorepos need
    workingDirectory = { mode = "auto" },
    -- Lint as you type rather than only on save
    run = "onType",
    -- Do not warn about files that ESLint is configured to ignore
    onIgnoredFiles = "off",
  },
}
