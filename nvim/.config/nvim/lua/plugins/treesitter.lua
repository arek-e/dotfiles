-- Treesitter.
--
-- On the `main` branch, which is a full rewrite of the plugin and is NOT
-- optional on Neovim 0.12.
--
-- The old `master` branch is locked upstream "for backward compatibility with
-- Nvim 0.11", and on 0.12 it genuinely breaks: its query directives assume
-- `match[capture_id]` is a single TSNode, while 0.12 changed matches to hold
-- lists of nodes (see the 0.12 news entry about directive-offset! and quantified
-- captures). The symptom is every markdown injection throwing
-- "attempt to call method 'range' (a nil value)" out of
-- nvim-treesitter/query_predicates.lua, which render-markdown hits immediately.
--
-- What changed against the master-branch setup:
--
--   * No `ensure_installed` and no `main = "nvim-treesitter.configs"`. Parsers
--     are installed with require("nvim-treesitter").install{}.
--   * No `highlight = { enable = true }`. Highlighting is Neovim's, started per
--     buffer with vim.treesitter.start().
--   * No `indent` or `incremental_selection` options; both are wired by hand
--     below.
--   * Needs the tree-sitter CLI (brew install tree-sitter-cli — note that the
--     `tree-sitter` formula is the library only) and a C compiler.
--
-- The plugin does not support lazy-loading, hence lazy = false.

local parsers = {
  -- Web / TypeScript
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  "html",
  "css",
  "json",
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
  "printf", -- required by bash injections
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Asynchronous, and a no-op once the parsers are present.
      require("nvim-treesitter").install(parsers)

      -- Highlighting, folds and indent are Neovim's now, enabled per buffer.
      -- Keyed off the parser actually being available rather than a filetype
      -- list, so a buffer whose parser is still installing degrades to regular
      -- syntax instead of erroring.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(event)
          local ft = vim.bo[event.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang or not vim.treesitter.language.add(lang) then
            return
          end

          pcall(vim.treesitter.start, event.buf)

          -- Treesitter folds, opened by default via foldlevel in options.lua
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"

          -- Indent is still marked experimental upstream. Skipped for the
          -- filetypes where it is worst, which is markdown and yaml.
          if ft ~= "markdown" and ft ~= "yaml" then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Auto close and rename JSX/HTML tag pairs. mini.pairs handles brackets and
  -- quotes; tags need the syntax tree, which is why this lives beside treesitter.
  --
  -- Uses its own setup(), NOT the nvim-treesitter.configs route, which upstream
  -- has deprecated. It needs the parsers installed above but is otherwise
  -- indifferent to which nvim-treesitter branch is in use.
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true, -- <div| -> <div></div>
        enable_rename = true, -- renaming one half renames the other
        enable_close_on_slash = false, -- </ closing the tag is more annoying than useful
      },
    },
  },

  -- Incremental selection, which `main` no longer provides. Kept because the
  -- master-branch config had it on <C-space>.
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      {
        "<C-space>",
        function()
          -- Grow the visual selection to the enclosing node.
          local ok = pcall(vim.cmd, "normal! gv")
          if not ok then
            vim.cmd("normal! v")
          end
          require("vim.treesitter").get_parser() -- ensure a parser exists
          local node = vim.treesitter.get_node()
          if not node then
            return
          end
          local parent = node:parent()
          local target = parent or node
          local srow, scol, erow, ecol = target:range()
          vim.fn.setpos("'<", { 0, srow + 1, scol + 1, 0 })
          vim.fn.setpos("'>", { 0, erow + 1, ecol, 0 })
          vim.cmd("normal! gv")
        end,
        mode = { "n", "x" },
        desc = "Expand selection to node",
      },
    },
  },
}
