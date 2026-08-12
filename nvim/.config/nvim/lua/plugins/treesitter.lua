-- Treesitter: syntax highlighting, indentation, incremental selection.
--
-- IMPORTANT: `branch = "master"` is load-bearing. nvim-treesitter's default
-- branch is now `main`, a full rewrite that requires Neovim 0.12 nightly. We
-- are on 0.11.x, where `master` is the supported branch. Without this pin,
-- lazy.nvim installs `main` and highlighting silently stops working.

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
