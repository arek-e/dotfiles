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

      -- Startup cost, not caching.
      --
      -- tsserver has no persistent cache: searching all 155 settings in vtsls'
      -- configuration schema finds no `cache`, `tsbuildinfo`, `incremental` or
      -- `composite`. It builds its program in memory on start and discards it on
      -- exit, so every session re-parses the project. That is the multi-second
      -- wait before the first reference or definition resolves.
      --
      -- These two only reduce the cost; they do not remove it. UNVERIFIED here:
      -- the effect only shows on a real monorepo, not on a synthetic test
      -- project, so this is reasoning rather than a measured improvement.
      --
      -- The actual caching lever is repo-side and out of nvim's reach: project
      -- references (`composite: true` plus `references`) let tsserver read a
      -- referenced project's generated .d.ts instead of parsing its source.
      tsserver = {
        -- Default is 3072 MB, which a large monorepo can exhaust; the resulting
        -- GC pressure looks exactly like "the language server is slow".
        maxTsServerMemory = 8192,
        -- useSyntaxServer is left at its "auto" default on purpose: it already
        -- runs a syntax-only server so completion and highlighting answer while
        -- the semantic program is still loading. watchOptions likewise.
      },

      -- Automatic type acquisition downloads @types/* in the background for
      -- untyped imports. Pointless in a repo that pins its own types.
      disableAutomaticTypeAcquisition = true,
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = inlay_hints,
    },
  },
}
