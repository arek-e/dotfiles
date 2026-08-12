-- Merged on top of nvim-lspconfig's lsp/lua_ls.lua.
-- Workspace library discovery is handled by lazydev.nvim, not here.

return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
      },
      codeLens = { enable = true },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      doc = {
        privateName = { "^_" },
      },
      -- Neovim injects a `vim` global that lua_ls cannot see on its own
      diagnostics = {
        globals = { "vim" },
        unusedLocalExclude = { "_*" },
      },
      format = {
        enable = false, -- stylua owns formatting, see .stylua.toml
      },
    },
  },
}
