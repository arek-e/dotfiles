return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Use biome when project has biome.json, otherwise prettier
      local function use_biome()
        return vim.fs.find({ "biome.json", "biome.jsonc" }, {
          upward = true,
          path = vim.fn.expand("%:p:h"),
        })[1] ~= nil
      end

      local web_formatter = function()
        if use_biome() then
          return { "biome" }
        end
        return { "prettier" }
      end

      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        javascript = web_formatter,
        javascriptreact = web_formatter,
        typescript = web_formatter,
        typescriptreact = web_formatter,
        json = web_formatter,
        jsonc = web_formatter,
        css = web_formatter,
      })

      -- Run biome via npx so it uses the project's version
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        biome = {
          command = "npx",
          args = { "biome", "format", "--write", "--stdin-file-path", "$FILENAME" },
          stdin = true,
        },
      })
    end,
  },
}
