# Pre-reset plugin inventory

Snapshot of the LazyVim-based config as it stood immediately before the factory
reset, captured so nothing is lost and each plugin can be reconsidered one by one.

- **Date:** 2026-08-12
- **Commit before reset:** `ac32b8c`
- **Neovim:** 0.11.6
- **Installed plugins:** 62 (`lazy-lock.json`), 79 dirs / 163 MB on disk
- **Headless startup:** ~32–36 ms
- **Base:** LazyVim distro + 5 extras + 10 custom spec files (2225 lines of Lua)

The old tree is recoverable at any time:

```sh
git show ac32b8c:nvim/.config/nvim/lua/plugins/editor.lua
git checkout ac32b8c -- nvim/.config/nvim/       # full restore
```

## How to read the verdict column

- **core** — went into the reset baseline
- **triage** — deliberately left out, decide one by one
- **drop** — recommend not restoring, reason given

---

## Distro and framework

| Plugin | Purpose | Verdict |
|---|---|---|
| `LazyVim/LazyVim` | Distro: opinionated defaults, keymaps, plugin set | **drop** — the thing being removed |
| `folke/lazy.nvim` | Plugin manager | **core** |
| LazyVim extras ×5 | typescript, json, tailwind, prettier, eslint | **drop** — reimplemented explicitly |

## LSP, completion, syntax

| Plugin | Purpose | Verdict |
|---|---|---|
| `neovim/nvim-lspconfig` | Server config data | **core** — now consumed via native `vim.lsp.config` |
| `mason.nvim` | Installs LSP servers/tools | **core** |
| `mason-lspconfig.nvim` | Bridged mason→lspconfig | **drop** — `vim.lsp.enable()` makes it redundant on 0.11 |
| `nvim-treesitter` | Syntax, indent, textobjects | **core** — pinned to `master`, see note below |
| `nvim-treesitter-textobjects` | `af`/`if` style TS textobjects | **triage** |
| `saghen/blink.cmp` | Completion engine | **triage** — needed for real coding |
| `friendly-snippets` | Snippet corpus | **triage** |
| `lazydev.nvim` | Lua/Neovim API awareness | **core** — only for editing this config |
| `nvimdev/lspsaga.nvim` | LSP UI: peek, finder, outline, calls | **triage** — 142 lines, replaced LazyVim+Trouble |
| `stevearc/conform.nvim` | Formatting, incl. biome/prettier autodetect | **triage** — logic worth keeping |
| `nvim-lint` | Linting (eslint) | **triage** |
| `b0o/SchemaStore.nvim` | JSON/YAML schemas | **triage** |
| `nvim-ts-autotag` | Auto close/rename HTML tags | **triage** |
| `ts-comments.nvim` | Context-aware `gc` | **triage** — 0.11 has native `gc` |
| `dmmulroy/tsc.nvim` | Async `tsc` runner | **drop** — overlaps LSP + Overseer |

> **Treesitter branch trap:** `origin/HEAD` on nvim-treesitter now points at `main`,
> which is a full rewrite requiring **Neovim 0.12 nightly**. On 0.11.6 the spec must
> pin `branch = "master"` explicitly or the config breaks on next install.

## Finding and navigation

| Plugin | Purpose | Verdict |
|---|---|---|
| `telescope.nvim` | Fuzzy finder | **triage** — pick this or snacks.picker, not both |
| `telescope-fzf-native.nvim` | Native fzf sorter | **triage** — follows telescope |
| `telescope-git-branch.nvim` | Files changed vs main | **triage** |
| `ThePrimeagen/harpoon` | Pinned file slots 1–5 | **triage** |
| `folke/flash.nvim` | Jump motions | **triage** |
| `nvim-spider` | camelCase-aware `w`/`e`/`b` | **triage** |
| `neo-tree.nvim` | File explorer, dotfiles shown | **triage** |
| `nvim-bqf` | Quickfix preview | **triage** |
| `folke/which-key.nvim` | Keymap discovery | **triage** |

## Git

| Plugin | Purpose | Verdict |
|---|---|---|
| `gitsigns.nvim` | Inline hunks, blame, stage hunk | **triage** — strongest git candidate |
| `diffview.nvim` | Full diff / file history, vs-main view | **triage** |
| `git-worktree.nvim` | Worktree switch/create | **triage** — overlaps shell `wt-park` |

## UI and theming

| Plugin | Purpose | Verdict |
|---|---|---|
| `tokyonight.nvim` | Theme (was active) | **triage** — keep exactly one |
| `catppuccin`, `kanagawa.nvim`, `rose-pine`, `nightfox.nvim`, `onedarkpro.nvim` | Alternate themes | **drop** — 5 unused themes loaded eagerly at `priority=1000` |
| `folke/snacks.nvim` | QoL bundle: notifier, indent, scroll, dim, zen, statuscolumn, words | **triage** — large surface, pick features deliberately |
| `folke/noice.nvim` | Cmdline/message replacement | **triage** — invasive |
| `nui.nvim` | UI lib for noice | follows noice |
| `lualine.nvim` | Statusline, custom transparent theme | **triage** |
| `bufferline.nvim` | Buffer tabs | **triage** |
| `nvim-web-devicons` / `mini.icons` | Icons | **triage** — both were installed |
| `dashboard-nvim` | Start screen w/ ASCII logo | **triage** |
| `smear-cursor.nvim` | Cursor trail animation | **drop** — pure cosmetic |
| `reactive.nvim` | Mode-aware highlights | **drop** — pure cosmetic |
| `focus.nvim` | Golden-ratio window autoresize | **drop** — fought manual splits |
| `dropbar.nvim` | Breadcrumbs | **drop** — already `enabled = false` |
| `nvim-notify` | Notifications | **drop** — already `enabled = false` |
| `indent-blankline.nvim` | Indent guides | **drop** — already `enabled = false` |
| `folke/trouble.nvim` | Diagnostics list | **drop** — already `enabled = false` |

## Editing

| Plugin | Purpose | Verdict |
|---|---|---|
| `nvim-ufo` | Fold UI w/ custom virt-text handler | **triage** |
| `promise-async` | ufo dep | follows ufo |
| `Wansmer/treesj` | Split/join code blocks | **triage** |
| `monaqa/dial.nvim` | Smart increment, large custom augend group | **triage** |
| `todo-comments.nvim` | TODO highlight + search | **triage** |
| `grug-far.nvim` | Project search/replace | **triage** |
| `mini.ai` | Extended textobjects | **triage** |
| `mini.pairs` | Autopairs | **triage** |
| `folke/persistence.nvim` | Session restore, branch-aware | **triage** |

## Terminal, tasks, AI

| Plugin | Purpose | Verdict |
|---|---|---|
| `toggleterm.nvim` | Float/split terminals, Claude swap | **triage** — overlaps herdr/cmux now |
| `overseer.nvim` | Task runner | **triage** |
| `claude-code.nvim` | Claude Code integration | **triage** |
| `avante.nvim` | AI assistant | **drop** — already `enabled = false`, still installed |
| `vim-tmux-navigator` | `C-hjkl` across tmux panes | **drop** — tmux replaced by herdr/cmux |

## Local config to preserve

Not plugins, but custom work worth carrying forward:

- `lua/config/options.lua` — vanilla options, no distro dependency. **Carried over as-is.**
- `lua/config/keymaps.lua` — Claude-buffer-aware terminal escapes, tmux window helper, `<leader>pw`.
- `lua/config/autocmds.lua` — transparency overrides gated on `vim.g.transparent`.
- `lua/config/cheatsheet.lua` — 347-line hand-written keybinding popup. Fully custom.
- `KEYBINDINGS.md` — keymap reference doc, will drift until the new set settles.
- `.stylua.toml` — formatter settings. **Kept.**
- `lua/plugins/formatting.lua` — biome-vs-prettier project autodetect. Worth porting.
