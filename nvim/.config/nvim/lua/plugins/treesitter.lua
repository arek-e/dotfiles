-- Treesitter: syntax highlighting, indentation, incremental selection.
--
-- IMPORTANT: `branch = "master"` is load-bearing. nvim-treesitter's default
-- branch is `main`, a full incompatible rewrite. Without this pin, lazy.nvim
-- installs `main` and this spec's options mean nothing, so highlighting
-- silently stops working.
--
-- Status as of Neovim 0.12.4: `main` is now installable (it needs 0.12+, which
-- we have) and is the actively developed branch. `master` is locked but still
-- functional, and is verified working here on 0.12.4. Migrating to `main` is a
-- rewrite of this file, not a branch flip: no ensure_installed, no
-- highlight.enable; parsers come from require("nvim-treesitter").install{} and
-- highlighting from vim.treesitter.start() in an ftplugin or FileType autocmd.
-- It also needs the tree-sitter CLI (brew install tree-sitter-cli; the
-- `tree-sitter` formula is the library only). Its indent support is still
-- marked experimental.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    lazy = false, -- highlighting must be live for the first buffer opened
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        -- Web / TypeScript
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
        "html",
        "css",
        "json",
        "jsonc",
        "graphql",
        -- Lua, for this config
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        -- Supporting formats
        "bash",
        "markdown",
        "markdown_inline",
        "yaml",
        "toml",
        "regex",
        "diff",
        "gitcommit",
      },
      auto_install = false, -- installs are explicit, via :TSInstall
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<BS>",
          scope_incremental = false,
        },
      },
    },
  },
}
