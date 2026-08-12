-- Formatting.
--
-- conform runs external formatters; it formats nothing itself. The per-project
-- choice comes from listing formatters in preference order with
-- `stop_after_first`: conform skips any whose command it cannot resolve and uses
-- the first that runs. The built-in definitions resolve `node_modules/.bin`
-- first (util.from_node_modules), so in practice:
--
--   oxc repos (leya) -> oxfmt     node_modules/.bin/oxfmt exists
--   biome repos      -> biome
--   everything else  -> prettier
--
-- That replaces the hand-written `vim.fs.find` biome detection the old config
-- had: conform's own definitions already do root detection — oxfmt via
-- .oxfmtrc.json / oxfmt.config.ts / vite.config.ts, biome via biome.json. None
-- of these wants a global install; the project's pinned version wins.
--
-- Lint autofix is deliberately NOT wired to save. See lua/plugins/lsp.lua:
-- eslint --fix and a formatter both rewriting the buffer on every write fight
-- each other, so fixAll is a keymap (<leader>cl) instead.

-- One table, shared by every web filetype.
local web = { "oxfmt", "biome", "prettier", stop_after_first = true }

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo", "FormatDisable", "FormatEnable" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer or selection",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = web,
        javascriptreact = web,
        typescript = web,
        typescriptreact = web,
        json = web,
        jsonc = web,
        css = web,
        scss = web,
        html = web,
        yaml = web,
        markdown = web,
        graphql = web,
        lua = { "stylua" }, -- reads .stylua.toml
      },

      format_on_save = function(bufnr)
        -- Escape hatches for a repo whose conventions differ from the
        -- formatter's, or a file to leave alone:
        --   :FormatDisable    this buffer
        --   :FormatDisable!   globally
        --   :FormatEnable     back on
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1500, lsp_format = "fallback" }
      end,

      -- Only complain when a formatter errors, not when a filetype has none
      notify_on_error = true,
      notify_no_formatters = false,
    },
    init = function()
      -- Make gq use conform, so the format operator matches what save does.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.g.disable_autoformat = true
          vim.notify("format on save: off (global)", vim.log.levels.WARN)
        else
          vim.b.disable_autoformat = true
          vim.notify("format on save: off (this buffer)", vim.log.levels.WARN)
        end
      end, { desc = "Disable format on save", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
        vim.notify("format on save: on", vim.log.levels.INFO)
      end, { desc = "Re-enable format on save" })
    end,
  },
}
