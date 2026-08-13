# Add-back queue

The baseline is deliberately incomplete. This is the queue of things that were
removed, ordered by how soon you are likely to miss them, so each one can be
added back on its own and judged on its own.

Rule for adding anything back: **use it from the baseline first and notice the
absence.** A plugin you cannot name a missing capability for does not go back in.

Old config for reference: `git show ac32b8c:nvim/.config/nvim/lua/plugins/<file>`

---

## Tier 1 — cleared

Every capability the baseline genuinely lacked has now been added: formatting
(conform), git signs and blame (gitsigns), autopairs (mini.pairs), a file
explorer (mini.files). What remains below is preference, not gaps.


## Added back so far

| Plugin | Date | Why |
|---|---|---|
| `mini.files` + `mini.icons` | 2026-08-12 | File explorer. Miller columns, so each level you descend adds a column on the right and the parents stay visible. Column widths are deliberately narrow (16/28/34) so five or six levels fit at once. Editing the listing renames/creates/deletes, and renames are forwarded to the LSP so imports follow. |
| `snacks.nvim` (dashboard + image) | 2026-08-12 | Start page. Replaced dashboard-nvim, which cannot render images. Shows the mark as a real image via Snacks.image over the Kitty graphics protocol, falling back to generated ASCII where the terminal cannot. chafa was tried first and abandoned: its `symbols` mode reads as a diamond at 24x12, and its `kitty` mode cannot work at all from a dashboard `terminal` section because nvim's libvterm swallows graphics escapes. Only `dashboard` and `image` are enabled out of the bundle. |

## Added 2026-08-12, second pass

| Plugin | Why |
|---|---|
| snacks `indent`, `notifier`, `input`, `words`, `scroll` | Already installed as part of snacks, so these were config flags rather than plugins. Between them they replace indent-blankline (5.0k stars), nvim-notify (3.6k), dressing (archived), and neoscroll (2.1k). |
| `lualine.nvim` | Statusline. Icons come from mini.icons' nvim-web-devicons shim, so no second icon plugin. |
| `render-markdown.nvim` | Renders markdown in the buffer. The one genuinely new capability of the batch, and the most actively maintained thing on the shortlist. |
| `gitsigns.nvim` | Signs, hunk navigation and IntelliJ-style inline blame. Chosen over mini.diff despite the config leaning on mini, because mini.diff has no blame at all and blame was the requirement; one plugin here versus two for the mini route. Staging left unmapped, since lazygit handles that. |
| `mini.pairs` | Autopairs, chosen over nvim-autopairs (4.1k stars) to stay in the mini ecosystem already used for the explorer and icons. Opening characters do not pair immediately before a word, which is the usual complaint about autopairs. Off in prompt buffers. |
| `conform.nvim` + `stylua` | Formatting, the last real gap. oxfmt/biome/prettier chosen by `stop_after_first` over resolvable binaries; stylua finally enforces the `.stylua.toml` that had sat unused since the reset. |
| `tiny-inline-diagnostic.nvim` | Replaces the built-in virtual_text, which appended whole messages to the line end and collided with code. `virtual_text = false` is set in lsp.lua so both do not draw at once. |

## Added 2026-08-13 (second batch)

| Plugin | Why |
|---|---|
| `SchemaStore.nvim` | Pure drop-in: `after/lsp/jsonls.lua` already required it and degraded gracefully. Installing it passes 1418 schemas to jsonls, so `package.json`, `tsconfig.json` and `biome.json` get validation and completion. |
| `nvim-ts-autotag` | Auto close and rename JSX/HTML tag pairs. mini.pairs covers brackets and quotes; tags need the syntax tree. Uses its own `setup()`, not the deprecated `nvim-treesitter.configs` route. |
| `todo-comments.nvim` | Highlights and searches TODO/FIX/HACK/NOTE. `<leader>st` searches, `]t`/`[t` navigate. |
| `flash.nvim` | Jump to any on-screen position by label. Takes `s` and `S` from substitute-char and substitute-line; `cl` and `cc` do the same thing, which is the trade nearly every flash config makes. Also labels `f`/`F`/`t`/`T` without needing a key. |

## Added 2026-08-13

| Plugin | Why |
|---|---|
| `glance.nvim` | Peek a definition or reference without leaving the buffer, on `gp`/`gP`/`gR`/`gM`. `gr` avoided: it is the native `gr*` prefix. |
| `tiny-code-action.nvim` | Code actions with a delta diff of what each would do, via the telescope picker. Replaces the native numbered list. |
| `telescope-undo.nvim` | Visual undo history with per-state diffs. No overlap with anything installed. |
| `telescope-frecency.nvim` | Frequency+recency file ranking, which `oldfiles` (pure recency) does not give. No sqlite needed. |
| `nvim-neoclip.lua` | Yank history. Persistence deliberately off: it would need sqlite.lua plus a sqlite lib that is not installed. |

## Tier 2 — strong candidates

| # | Candidate | Buys you | Watch out for |
|---|---|---|---|
| 4 | `harpoon` | Pinned file slots 1–5. Genuinely different from a fuzzy finder. | Old binding was `<leader>A` to add, to avoid a Claude Code clash. |
| 5 | `diffview.nvim` | `origin/main...HEAD` review view, file history. | Overlaps `:Gitsigns diffthis` for single files. |
| 6 | `nvim-treesitter-textobjects` | `af`/`if`/`ac` function and class textobjects. | Pin `branch = "main"` to match nvim-treesitter, which now tracks `main`. The old note here said `master`, which was correct only while treesitter was on `master`. |

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

- Images require herdr's `experimental.kitty_graphics`, which is enabled in this
  repo's herdr config. herdr must be restarted, not just reloaded, for it.
- `~/.local/share/nvim/{lazy,mason}.reset-bak` and
  `~/.local/state/nvim/lazy.reset-bak` hold the pre-reset state. Delete once the
  new config has survived a few real days of work.
- **Done 2026-08-12:** `vscode-langservers-extracted` is now a single global npm
  install, and the four duplicate mason packages (json, html, css, eslint) are
  gone. Mason dropped from 433 MB to 60 MB. Those four servers now resolve via
  Volta shims, so they depend on `$VOLTA_HOME/bin` being on PATH; launching nvim
  from a non-shell context could break them. Verified attaching after the change.
