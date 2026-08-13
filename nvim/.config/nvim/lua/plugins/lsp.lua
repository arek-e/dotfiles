-- LSP.
--
-- On Neovim 0.11 the native API does the wiring, so there is no
-- mason-lspconfig bridge here. The split is:
--
--   * nvim-lspconfig  ships `lsp/<server>.lua` with cmd/filetypes/root markers
--   * after/lsp/<server>.lua  holds our overrides, merged on top by the runtime
--   * vim.lsp.enable()  turns a server on
--
-- To add a server: create after/lsp/<name>.lua (or nothing at all if the
-- defaults suffice) and append its name to the `servers` list below.

-- Both eslint and oxlint are listed, and they will not collide: each has
-- workspace_required = true and a root_dir that demands its own config file
-- (.eslintrc*/eslint.config.* versus .oxlintrc.json/oxlint.config.ts), so only
-- the one a project actually uses attaches. Both resolve node_modules/.bin
-- first, so neither needs a global install.
local servers = {
  "lua_ls",
  "vtsls", -- TypeScript / JavaScript
  "html",
  "cssls",
  "tailwindcss",
  "jsonls",
  "eslint",
  "oxlint", -- the oxc linter, used in place of eslint in some repos
}

return {
  -- Installer for language servers and formatters.
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonInstallServers" },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Mason has no ensure_installed of its own, and pulling in
      -- mason-tool-installer for this would be a whole extra plugin.
      -- :MasonInstallServers installs anything missing.
      vim.api.nvim_create_user_command("MasonInstallServers", function()
        local registry = require("mason-registry")
        registry.refresh(function()
          -- Mason package names differ from LSP server names in places.
          local packages = {
            "lua-language-server",
            "vtsls",
            "html-lsp",
            "css-lsp",
            "tailwindcss-language-server",
            "json-lsp",
            "eslint-lsp",
          }
          for _, name in ipairs(packages) do
            local ok, pkg = pcall(registry.get_package, name)
            if not ok then
              vim.notify("Unknown mason package: " .. name, vim.log.levels.WARN)
            elseif not pkg:is_installed() then
              vim.notify("Installing " .. name, vim.log.levels.INFO)
              pkg:install()
            end
          end
        end)
      end, { desc = "Install all language servers this config expects" })
    end,
  },

  -- Neovim/Lua API awareness when editing this config. Replaces the old
  -- hand-maintained lua_ls workspace library list.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      -- Diagnostic presentation
      vim.diagnostic.config({
        severity_sort = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        -- Off on purpose: tiny-inline-diagnostic renders these instead, wrapped
        -- and boxed and only for the cursor's line. Leaving this on draws both
        -- at once, one over the other. See lua/plugins/diagnostics.lua.
        virtual_text = false,
        float = {
          border = "rounded",
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })

      -- Rounded borders for hover and signature help
      vim.o.winborder = "rounded"

      -- Buffer-local keymaps, set only once a server actually attaches.
      -- grn, gra, grr, gri and gO are native 0.11 defaults, so they are not
      -- redefined here; these are the additions.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(event)
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          -- <leader>ca is intentionally NOT mapped here. tiny-code-action owns
          -- it (see plugins/lsp-ui.lua) and provides a diff preview; a
          -- buffer-local mapping set here would take precedence over its global
          -- one and silently win.

          -- Inlay hints, off by default, toggled per buffer
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>ch", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Toggle inlay hints")
          end
        end,
      })

      -- Lint autofix is a keymap, not a save hook.
      --
      -- Both eslint and oxlint provide a fixAll command, and lspconfig's own
      -- on_attach is what creates it (LspEslintFixAll / LspOxlintFixAll). It
      -- used to run on BufWritePre here, which was a mistake once conform
      -- arrived: --fix and a formatter both rewriting the buffer on every write
      -- fight over it, and eslint's stylistic fixes then get reformatted anyway.
      -- So conform owns save, and this runs the linter's fixes on demand.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lint_fixall", { clear = true }),
        callback = function(event)
          for _, cmd in ipairs({ "LspEslintFixAll", "LspOxlintFixAll" }) do
            if vim.fn.exists(":" .. cmd) == 2 then
              vim.keymap.set("n", "<leader>cl", "<cmd>" .. cmd .. "<cr>", {
                buffer = event.buf,
                desc = "LSP: lint fix all (" .. cmd:gsub("^Lsp", ""):gsub("FixAll$", "") .. ")",
              })
            end
          end
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
