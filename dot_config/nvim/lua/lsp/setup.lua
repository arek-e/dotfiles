-- Setup installer & lsp configs
local typescript_ok, typescript = pcall(require, 'typescript')
local mason_ok, mason = pcall(require, 'mason')
local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')
local rt = require("rust-tools")

if not mason_ok or not mason_lsp_ok then
  return
end

mason.setup {
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = EcoVim.ui.float.border or "rounded",
  }
}

mason_lsp.setup {
  -- A list of servers to automatically install if they're not already installed
  ensure_installed = { "bash-language-server", "css-lsp", "eslint-lsp", "graphql-language-service-cli", "html-lsp",
    "json-lsp", "lua-language-server", "tailwindcss-language-server", "typescript-language-server",
    "vetur-vls", "vue-language-server", "chrome-debug-adapter", "node-debug2-adapter" },

  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  automatic_installation = true,
}

local lspconfig = require("lspconfig")

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = EcoVim.ui.float.border, focusable = true } ),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = EcoVim.ui.float.border }),
  ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
    { virtual_text = EcoVim.lsp.virtual_text }),
}

local function on_attach(client, bufnr)
  -- set up buffer keymaps, etc.
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
  capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

-- local opts = {
--     tools = { -- rust-tools options
--         autoSetHints = true,
--         hover_with_actions = true,
--         inlay_hints = {
--             show_parameter_hints = false,
--             parameter_hints_prefix = "",
--             other_hints_prefix = "",
--         },
--     },
--     server = {
--         -- on_attach is a callback called when the language server attachs to the buffer
--         on_attach = on_attach,
--         settings = {
--             ["rust-analyzer"] = {
--                 checkOnSave = {
--                     command = "clippy"
--                 },
--             }
--         }
--     },
-- }


-- Order matters

rt.setup({
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(
        "/home/arek/.vscode/extensions/vadimcn.vscode-lldb-1.7.3/adapter/codelldb",
        "/home/arek/.vscode/extensions/vadimcn.vscode-lldb-1.7.3/lldb/lib/liblldb.so"
    ),
  },
  server = {
    standalone = true,
    -- on_attach = function(_, bufnr)
    --   
    -- end,
    capabilities = capabilities,
  },
})

-- It enables tsserver automatically so no need to call lspconfig.tsserver.setup
if typescript_ok then
  typescript.setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    -- LSP Config options
    server = {
      capabilities = require('lsp.servers.tsserver').capabilities,
      handlers = handlers,
      on_attach = require('lsp.servers.tsserver').on_attach,
    }
  })
end

lspconfig.tailwindcss.setup {
  capabilities = require('lsp.servers.tsserver').capabilities,
  filetypes = require('lsp.servers.tailwindcss').filetypes,
  handlers = handlers,
  init_options = require('lsp.servers.tailwindcss').init_options,
  on_attach = require('lsp.servers.tailwindcss').on_attach,
  settings = require('lsp.servers.tailwindcss').settings,
}

lspconfig.eslint.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = require('lsp.servers.eslint').on_attach,
  settings = require('lsp.servers.eslint').settings,
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
  handlers = handlers,
  on_attach = on_attach,
  settings = require('lsp.servers.jsonls').settings,
}

lspconfig.sumneko_lua.setup {
  handlers = handlers,
  on_attach = on_attach,
  settings = require('lsp.servers.sumneko_lua').settings,
}

lspconfig.vuels.setup {
  filetypes = require('lsp.servers.vuels').filetypes,
  handlers = handlers,
  init_options = require('lsp.servers.vuels').init_options,
  on_attach = on_attach,
}
-- lspconfig.rust_analyzer.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   handlers = handlers,
--   rt.setup({
--       server = {
--         -- standalone file support
--         -- setting it to false may improve startup time
--         standalone = true,
--       }, -- rust-analyer options
--
--       -- debugging stuff
--       -- dap = {
--       --   adapter = {
--       --     type = "executable",
--       --     command = "lldb-vscode",
--       --     name = "rt_lldb",
--       --   },
--       -- },
--     }
--   ),
--
-- }

for _, server in ipairs { "bashls", "cssls", "graphql", "html", "volar" } do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
  }
end
