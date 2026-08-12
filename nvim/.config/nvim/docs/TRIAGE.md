# Add-back queue

The baseline is deliberately incomplete. This is the queue of things that were
removed, ordered by how soon you are likely to miss them, so each one can be
added back on its own and judged on its own.

Rule for adding anything back: **use it from the baseline first and notice the
absence.** A plugin you cannot name a missing capability for does not go back in.

Old config for reference: `git show ac32b8c:nvim/.config/nvim/lua/plugins/<file>`

---

## Tier 1 — real gaps in the baseline

These are capabilities the baseline genuinely lacks, not conveniences.

| # | Candidate | The gap it fills | Notes |
|---|---|---|---|
| 1 | `conform.nvim` | **Nothing formats code right now.** Only ESLint fix-all on save exists. | Your old `formatting.lua` had good biome-vs-prettier project autodetect. Port it. |
| 2 | `gitsigns.nvim` | No inline hunks, no blame, no stage-hunk. | Your old config had 15 well-chosen mappings. Strongest single candidate. |
| 3 | `mini.pairs` or similar | No autopairs. | `blink.cmp` already does `auto_brackets` for completions, so this is only for hand-typed pairs. |

## Added back so far

| Plugin | Date | Why |
|---|---|---|
| `mini.files` + `mini.icons` | 2026-08-12 | File explorer. Miller columns, so each level you descend adds a column on the right and the parents stay visible. Column widths are deliberately narrow (16/28/34) so five or six levels fit at once. Editing the listing renames/creates/deletes, and renames are forwarded to the LSP so imports follow. |
| `snacks.nvim` (dashboard + image) | 2026-08-12 | Start page. Replaced dashboard-nvim, which cannot render images. Shows the mark as a real image over the Kitty graphics protocol via chafa, falling back to generated ASCII under a multiplexer or an unsupporting terminal. chafa's own `symbols` mode was tried as a middle tier and dropped: at 24x12 it only picks lower-half blocks and reads as a diamond, so the hand-generated ASCII is better. Only `dashboard` and `image` are enabled out of the bundle. |

## Tier 2 — strong candidates

| # | Candidate | Buys you | Watch out for |
|---|---|---|---|
| 4 | `harpoon` | Pinned file slots 1–5. Genuinely different from a fuzzy finder. | Old binding was `<leader>A` to add, to avoid a Claude Code clash. |
| 5 | `diffview.nvim` | `origin/main...HEAD` review view, file history. | Overlaps `:Gitsigns diffthis` for single files. |
| 6 | `flash.nvim` | Fast on-screen jumps. | Clashed with Claude Code bindings before; check that. |
| 7 | `todo-comments.nvim` | TODO/FIX highlighting and search. | Cheap, low risk. |
| 8 | `nvim-ts-autotag` | Auto close/rename JSX and HTML tags. | Near-essential for React work. |
| 9 | `SchemaStore.nvim` | JSON/YAML schema validation. | `after/lsp/jsonls.lua` **already tries to require it** and degrades gracefully, so this is a drop-in. |
| 10 | `lualine.nvim` | Statusline. `laststatus=3` currently shows the plain one. | Old theme hardcoded tokyonight hex; needs regruvboxing. |
| 11 | `nvim-treesitter-textobjects` | `af`/`if`/`ac` function and class textobjects. | Must also be pinned to `master`, same 0.12 trap as treesitter. |

## Tier 3 — was in the old config, justify before restoring

| Candidate | Question to answer first |
|---|---|
| `lspsaga.nvim` | The baseline uses native LSP plus telescope pickers. Is the saga UI actually better for you, or was it 142 lines of config for a prettier hover? |
| `toggleterm.nvim` | You just moved to herdr/cmux for multiplexing. Do you still want terminals *inside* nvim? |
| `claude-code.nvim` | Same question. Claude Code in a herdr pane may be better than in a nvim float. |
| `overseer.nvim` | Did you ever run a task through it, or was `<leader>o*` dead weight? |
| `grug-far.nvim` | Project-wide replace. Telescope plus `:cdo` covers some of this. |
| `nvim-ufo` | Treesitter folds are already wired via `foldlevel=99`. Ufo adds the fold preview UI. |
| `dial.nvim` | The custom augend group was genuinely nice. Native `C-a` handles plain numbers. |
| `treesj` | Split/join. Real but niche. |
| `nvim-spider` | camelCase `w`/`e`/`b`. Muscle-memory dependent. |
| `nvim-bqf` | Better quickfix. Only matters if you live in the quickfix list. |
| `persistence.nvim` | Session restore. Overlaps herdr session restore, which you just enabled. |
| `bufferline.nvim` | Buffer tabs. You have `[b` / `]b` and `<leader>fb`. |
| `noice.nvim` | Invasive cmdline replacement. Add last, if at all. |
| `snacks.nvim` extras | Now installed for dashboard and image. Other features (picker, notifier, indent, scroll, dim, zen, statuscolumn, words) are still off; enable one at a time. |

## Explicitly not coming back

| Dropped | Reason |
|---|---|
| `LazyVim` + 5 extras | The distro being removed. Everything it gave you is now explicit. |
| 5 spare colorschemes | catppuccin, kanagawa, rose-pine, nightfox, onedarkpro. All eager at `priority=1000`. |
| `smear-cursor.nvim` | Cursor trail. Cosmetic. |
| `reactive.nvim` | Mode-aware highlights. Cosmetic. |
| `focus.nvim` | Golden-ratio autoresize fought manual splits. |
| `vim-tmux-navigator` | tmux is gone, replaced by herdr/cmux. |
| `avante.nvim` | Was `enabled = false` and still installed. |
| `dropbar`, `nvim-notify`, `indent-blankline`, `trouble` | All already `enabled = false`. |
| `tsc.nvim` | vtsls provides the diagnostics. |
| `mason-lspconfig.nvim` | `vim.lsp.enable()` makes it redundant on 0.11. |
| `ts-comments.nvim` | 0.11 has native context-aware `gc`. |

## Housekeeping

- `stylua` is not installed, so `.stylua.toml` is currently unenforced.
  `brew install stylua`, or add it to mason and wire it into conform at item 1.
- `~/.local/share/nvim/{lazy,mason}.reset-bak` and
  `~/.local/state/nvim/lazy.reset-bak` hold the pre-reset state. Delete once the
  new config has survived a few real days of work.
- **Done 2026-08-12:** `vscode-langservers-extracted` is now a single global npm
  install, and the four duplicate mason packages (json, html, css, eslint) are
  gone. Mason dropped from 433 MB to 60 MB. Those four servers now resolve via
  Volta shims, so they depend on `$VOLTA_HOME/bin` being on PATH; launching nvim
  from a non-shell context could break them. Verified attaching after the change.
