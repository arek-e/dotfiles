-- TypeScript / JavaScript.
--
-- vtsls wraps tsserver and exposes it over standard LSP, which means no
-- typescript-tools or tsc.nvim plugin is needed for diagnostics.

local inlay_hints = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

return {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true, -- respect the project's own TypeScript
      experimental = {
        maxInlayHintLength = 30,
        completion = { enableServerSideFuzzyMatch = true },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = inlay_hints,
      preferences = {
        importModuleSpecifier = "non-relative",
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = inlay_hints,
    },
  },
}
