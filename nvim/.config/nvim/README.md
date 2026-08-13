# Neovim configuration

A hand-rolled config on plain lazy.nvim. No distro. Targets TypeScript and web
work, plus Lua for editing this config.

Requires **Neovim 0.11+**, running on **0.12.4**. It uses the native
`vim.lsp.config` / `vim.lsp.enable` API and `vim.hl`.

## Structure

```
init.lua                  Leader keys, then four requires. Nothing else.
lua/
  config/
    lazy.lua              lazy.nvim bootstrap and setup
    options.lua           Editor options. References no plugin.
    keymaps.lua           Plugin-independent keymaps only.
    autocmds.lua          Autocommands, incl. transparency
  util/
    graphics.lua          Can this terminal actually display images?
  plugins/                One file per concern; every file is imported
    colorscheme.lua
    completion.lua
    diagnostics.lua       tiny-inline-diagnostic
    formatting.lua        conform: oxfmt / biome / prettier / stylua
    lualine.lua
    edgy.lua              split windows pinned to screen edges
    git.lua               gitsigns: signs, hunks, inline blame
    icons.lua             mini.icons, eager (telescope/lualine need it early)
    lsp-ui.lua            glance (peek) + tiny-code-action (diff preview)
    markdown.lua          render-markdown
    pairs.lua             mini.pairs
    session.lua           persistence: restore buffers and layout
    winbar.lua            incline + treesitter-context
    snacks.lua            Start page, images, indent, notifier, input,
                          words, scroll
    explorer.lua
    lsp.lua
    telescope.lua
    treesitter.lua
    which-key.lua
after/
  ftplugin/
    markdown.lua          conceallevel etc. for render-markdown
assets/
  legora-mark.png         The mark, rasterised from its geometry
  legora-mark-light.png   Same, lifted for dark backgrounds
after/
  lsp/                    Per-server LSP overrides, merged over nvim-lspconfig
    lua_ls.lua
    vtsls.lua
    jsonls.lua
    eslint.lua
    tailwindcss.lua
docs/
  INVENTORY-pre-reset.md  What was installed before the reset, and why each
                          plugin was kept or dropped
  TRIAGE.md               The add-back queue
```

Three conventions keep this navigable:

1. **Plugin keymaps live in the plugin's own spec**, under `keys`, so lazy.nvim
   can use them as load triggers. `config/keymaps.lua` is only for mappings that
   work without any plugin.
2. **LSP server settings live in `after/lsp/<name>.lua`**, never in a giant
   table inside `lsp.lua`. Adding a server is: create that file, append the name
   to the `servers` list.
3. **Lazy by default.** `config/lazy.lua` sets `defaults = { lazy = true }`, so
   anything eager has to say `lazy = false` and is easy to audit. Currently only
   the colorscheme and treesitter are eager.

## Plugins

Thirty-one, of which twenty-six are declared and five are dependencies.

| Plugin | Why |
|---|---|
| `lazy.nvim` | Plugin manager |
| `gruvbox.nvim` | Colorscheme, matches the Ghostty/herdr theme |
| `nvim-treesitter` | Highlighting, indent, incremental selection |
| `nvim-lspconfig` | Server definitions, consumed by the native 0.11 API |
| `mason.nvim` | Installs the language servers |
| `lazydev.nvim` | Neovim Lua API awareness when editing this config |
| `blink.cmp` | Completion |
| `friendly-snippets` | Snippet corpus (dependency) |
| `telescope.nvim` | Fuzzy finder |
| `telescope-fzf-native.nvim` | Compiled sorter for telescope |
| `telescope-undo.nvim` | Visual undo history with diffs |
| `telescope-frecency.nvim` | Files ranked by frequency + recency |
| `nvim-neoclip.lua` | Yank history (session-scoped) |
| `plenary.nvim` | Telescope dependency |
| `mini.files` | File explorer, Miller columns. Org is `nvim-mini`, not `echasnovski`. |
| `mini.icons` | Icons, and stands in for nvim-web-devicons via its shim |
| `snacks.nvim` | Start page, inline images, indent guides, notifications, `vim.ui.input`, LSP reference highlight, smooth scroll. Seven of its ~34 modules; the rest stay off. |
| `lualine.nvim` | Statusline |
| `render-markdown.nvim` | Renders markdown in the buffer |
| `tiny-inline-diagnostic.nvim` | Diagnostic display, replaces `virtual_text` |
| `conform.nvim` | Formatting, on save and on `<leader>cf` |
| `mini.pairs` | Autopairs for hand-typed brackets and quotes |
| `gitsigns.nvim` | Git signs, hunk navigation, inline blame |
| `edgy.nvim` | Pins quickfix, help and terminal splits to screen edges |
| `fidget.nvim` | LSP progress, so a slow server is visibly working |
| `persistence.nvim` | Session restore, per directory and git branch |
| `incline.nvim` | Per-window filename label, top right |
| `nvim-treesitter-context` | Pins the enclosing scope to the top of the window |
| `glance.nvim` | Peek definitions/references without leaving the buffer |
| `tiny-code-action.nvim` | Code actions with a delta diff preview |
| `mini.icons` | Icons, and stands in for nvim-web-devicons via its shim |
| `which-key.nvim` | Keymap discovery |

Telescope and mini.files split the work: telescope answers "where is X",
mini.files answers "what is around here" and lets you restructure it by editing
the listing as text (`=` to apply).

### Language servers

`lua_ls`, `vtsls`, `html`, `cssls`, `tailwindcss`, `jsonls`, `eslint`, `oxlint`.

eslint and oxlint are both enabled and do not collide: each has
`workspace_required` and a `root_dir` demanding its own config file, so only the
one a project actually uses attaches. Both resolve `node_modules/.bin` first.

Install or repair them with `:MasonInstallServers`, a small user command defined
in `lua/plugins/lsp.lua` so that no extra plugin is needed for this.

## Formatting

`conform` picks the formatter by listing candidates in order with
`stop_after_first`, skipping any whose binary it cannot resolve:

| Repo | Formatter |
|---|---|
| oxc (`node_modules/.bin/oxfmt`) | `oxfmt` |
| biome (`biome.json`) | `biome` |
| anything else | `prettier` |
| Lua | `stylua`, via `.stylua.toml` |

All three resolve `node_modules/.bin` before PATH, so the project's pinned
version wins and none of them needs a global install. `<leader>cf` formats
manually; `:FormatDisable[!]` and `:FormatEnable` toggle format-on-save per
buffer or globally.

Lint autofix is `<leader>cl`, not a save hook, and runs whichever of
`LspEslintFixAll` / `LspOxlintFixAll` the attached server provides. It used to
run on `BufWritePre`, which was wrong once conform existed: `--fix` and a
formatter both rewriting the buffer on every write fight over it.

## Git

Inline blame is on by default, IntelliJ style: author, relative time and commit
subject as virtual text at the end of the cursor's line, after a 300 ms delay.
`<leader>ght` toggles it, `<leader>ghb` opens the full blame for the line.

Staging is deliberately not mapped — lazygit is bound to `prefix+alt+g` in herdr
and that is where staging happens. `gitsigns.stage_hunk` exists if that changes.

## When the LSP feels slow

Measured on a synthetic 320-reference TypeScript project: the references request
is **28 ms warm** and **119 ms cold**, and telescope adds **94 ms** on top. So
neither is the delay.

The multi-second wait is tsserver indexing, and it happens on the first request
after opening a project. vtsls *does* emit `$/progress` for that phase
("Analyzing … and its dependencies", "Initializing tsconfig.json"), which is why
there are now two progress indicators: fidget bottom right, and lualine's
`lsp_status` spinner. It does **not** emit progress for the references request
itself, but at 28 ms that needs none.

snacks.notifier was moved to the top right for this — it and fidget both default
to the bottom right and overlapped.

## Sessions

`<leader>qs` restores the session for this directory and git branch, `<leader>ql`
the last one anywhere, `<leader>qS` picks from a list, `<leader>qd` stops saving.
The dashboard has it on `s`. Saving is automatic on exit; only restoring is a
keypress, so `nvim somefile` never surprises you by reopening yesterday's twenty
buffers.

This does not overlap herdr's session restore: herdr brings back workspaces,
tabs and panes, and knows nothing about what was open inside nvim.

Transient windows (edgy, mini.files, terminals, the dashboard) are closed on
`PersistenceSavePre`, or they come back empty and misplaced.

## Code actions

`gra` and `<leader>ca` both go to tiny-code-action, so the same action never has
two presentations. Disabled actions are filtered out, which is not cosmetic:
tsserver advertises every refactor it knows at the cursor and marks most
`disabled` for that position, and tiny-code-action resolves each one to build its
diff. Resolving a disabled "Extract to type" makes tsserver throw
`Debug Failure. False expression: Expected to find a range to extract`, which
surfaced as "Unable to preview code action". Filtering on the LSP `disabled`
field removes both the noise and the crash: 17+ entries became 3.

## Top of the window

Two different answers to "where am I", neither in the winbar (edgy already uses
that line for its own window titles):

- **incline** floats the filename, modified marker and per-buffer diagnostic
  counts in each window's top right. This is information the statusline cannot
  give: `laststatus = 3` means one bar for the whole editor, so with a split it
  could only ever name one of the two buffers. The filename was removed from
  lualine in favour of it. zindex 30, below floats, so it never covers telescope,
  glance or a code action preview.
- **treesitter-context** pins the enclosing scope to the top, so deep in a
  function body you still see its signature. `<leader>uc` toggles it, `[c` jumps
  to the context start. Note `min_window_height = 20`: it deliberately does
  nothing in a short window, which looks like it is broken if you test in one.

## Statusline

Sections: mode letter, branch + git diff counts, filename relative to cwd, then
attached LSP servers as icons, diagnostics, and position. Three components appear
only when they apply, so they cost no width at rest: an active macro recording
(red `@q`), the search hit count, and the selected line count in visual mode.
Pending plugin updates show from `lazy.status`.

Position reads `Ln 382/410  Col 31`. The defaults were `progress` and `location`
-- "94%" and "382:31" -- where the percentage duplicates what the line number
implies and neither says how long the file is.

LSP servers show as icons pulled from **mini.icons**, never as hardcoded
codepoints, so a glyph cannot be missing from the installed icon set. eslint and
oxlint map to their config files (which `icons.lua` gives a linter glyph);
tailwindcss maps to `scss` purely because that is a different colour from `css`
and so does not collapse into `cssls` when both attach. There is no separate
filetype icon component: it printed the same TypeScript glyph twice in a row.

The progress spinner counts `LspProgress` begin/end events rather than reading
`vim.lsp.status()`, which accumulates and was observed still returning a stale
"Analyzing ..." string well after the work had finished.

Two things here are easy to break:

- **The theme is a hand-written table**, not `auto` and not a shipped one. `auto`
  derives from gruvbox's `transparent_mode` and yields sections that are entirely
  `bg=NONE`, which leaves the mode indicator uncoloured and powerline separators
  invisible. Shipped `gruvbox_dark` puts *grey* on normal mode and green on
  command, which reads flat and inverts the usual convention.
- **Separators are UTF-8 byte escapes**, not pasted glyphs. Literal Nerd Font
  characters get silently stripped by some tooling, which leaves the strings empty
  and the separators simply absent.

Note that lualine creates its highlight groups on first *render*, so
`nvim_get_hl` on `lualine_*` returns nothing under `--headless`. Check colours in
a real UI or the answer is meaningless.

## Gotchas worth knowing

- **nvim-treesitter is on `branch = "main"`, and must be on 0.12.** The old
  `master` branch is locked upstream for 0.11 and genuinely breaks on 0.12: its
  query directives assume `match[capture_id]` is a single node, while 0.12
  changed matches to hold lists. Every markdown injection throws
  "attempt to call method 'range' (a nil value)".
- **Parsers live in `~/.local/share/nvim/site`, and `parser-info/` is the
  source of truth.** Deleting `parser/` without also deleting `parser-info/`
  makes a reinstall a silent no-op: install reports success against the recorded
  revisions while no `.so` exists. Use `install({...}, { force = true })`, or
  remove both directories.
- **0.12 bundles some parsers** (`c`, `lua`, `markdown`, `markdown_inline`,
  `query`, `vim`, `vimdoc`) in `lib/nvim/parser/`, so those never appear in the
  site directory.
- **`jsonc` is not a parser on `main`**; it maps to `json`. Listing it logs
  "skipping unsupported language".
- **Do not define `on_attach` in `after/lsp/eslint.lua`.** Config tables merge
  with `force`, so it would replace nvim-lspconfig's own `on_attach` and destroy
  the `LspEslintFixAll` command. The wrapper in `lua/plugins/lsp.lua` captures
  the base function and calls it first.
- **Images need `experimental.kitty_graphics` in herdr.** herdr does implement
  the Kitty graphics protocol, but it is off by default; without it herdr
  refuses with "pane graphics require experimental.kitty_graphics". It is
  enabled in `herdr/.config/herdr/config.toml` in this repo. A
  `herdr server reload-config` is **not** enough — the painting is client-side,
  so herdr has to be restarted for the flag to take effect.

  `lua/util/graphics.lua` reads that flag rather than assuming either way, and
  is the single source of truth. Do not gate on
  `Snacks.image.supports_terminal()` alone: herdr relays the terminal *version
  query* to Ghostty, so that check returns true even when the graphics data is
  being dropped, which reserves space and draws nothing.
- **chafa in a dashboard `terminal` section can never work**, even where
  graphics do: a terminal section runs inside nvim's own terminal emulator, and
  libvterm swallows graphics escapes instead of forwarding them.
- **Snacks.image supplies its own vertical space** via `virt_lines` on the
  placement extmark. Reserving a block of blank lines *as well* stacks the two
  and leaves the mark stranded far above the menu; the image section is one
  anchor line only.
- **netrw is deliberately left enabled** in `config/lazy.lua`, as a fallback
  path for browsing a directory that does not depend on mini.files loading.
- **`json-lsp`, `html-lsp`, `css-lsp` and `eslint-lsp` are not installed via
  mason.** All four are the same npm package (`vscode-langservers-extracted`),
  which mason would install ~93 MB at a time. It is one global npm install
  instead, so those four resolve from `$VOLTA_HOME/bin` and depend on it being
  on PATH. `lua_ls`, `vtsls` and `tailwindcss` still come from mason.

## First launch

```sh
npm i -g vscode-langservers-extracted   # json, html, css and eslint servers
nvim                                    # lazy.nvim bootstraps and installs
:MasonInstallServers                    # lua_ls, vtsls, tailwindcss
:checkhealth
```

## Keymaps

Leader is `Space`. `<leader>?` shows what is bound in the current buffer, and
`<leader>sk` searches all keymaps — both are more trustworthy than a table in a
README, which is why there is no exhaustive list here.

LSP location lists go through **glance**, not the quickfix list and not
telescope: `gd`, `grr`, `gri` and `grt` open a peek window that keeps you in the
buffer. There is one key per action; an earlier telescope-based set doing the
same job from different keys was removed. `gr` is never mapped, being the prefix
for the native `gr*` family. Telescope keeps the pickers glance has no
equivalent for: `<leader>ss` / `<leader>sS` symbols and `<leader>sd` diagnostics.

Hover (`K`) needs no plugin: `vim.o.winborder` gives it a rounded border and
render-markdown renders the float automatically via its default `buftype.nofile`
override. `gp` / `gP` / `gR` / `gM` peek definitions, type definitions,
references and implementations via glance. `gr` is deliberately left unmapped
because it is the prefix for the native `gr*` family.

The 0.11 native LSP defaults are in play: `grn` rename, `gra` code action,
`grr` references, `gri` implementation, `gO` document symbols, `]d` / `[d`
diagnostics. `lua/plugins/lsp.lua` adds `gd`, `gD`, `gy`, `K`, `<leader>cr`,
`<leader>ca` and `<leader>ch`.
