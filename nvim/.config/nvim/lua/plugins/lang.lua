return {
  -- Treesitter - syntax highlighting and more
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        -- Web
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "json",
        "jsonc",
        "yaml",
        "toml",
        -- Backend
        "go",
        "rust",
        "python",
        -- Config/IaC
        "hcl", -- Terraform/Pulumi
        "dockerfile",
        "bash",
        -- Misc
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "regex",
        "graphql",
        "prisma",
        "sql",
      })
    end,
  },

  -- Auto close and rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Better TypeScript errors (if you need more than vtsls provides)
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = {},
  },

  -- JSON schemas
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
}
