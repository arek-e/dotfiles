# Neovim configuration

A hand-rolled config on plain lazy.nvim. No distro. Targets TypeScript and web
work, plus Lua for editing this config.

Requires **Neovim 0.11+** (it uses the native `vim.lsp.config` / `vim.lsp.enable`
API and `vim.hl`).

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
    dashboard.lua         Start page; renders the mark as a real image
                          where the terminal allows it, ASCII otherwise
    explorer.lua
    lsp.lua
    telescope.lua
    treesitter.lua
    which-key.lua
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

Fifteen, of which twelve are declared and three are dependencies.

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
| `plenary.nvim` | Telescope dependency |
| `mini.files` | File explorer, Miller columns |
| `mini.icons` | Icons for the explorer (dependency) |
| `snacks.nvim` | Start page and inline image rendering. Only `dashboard` and `image` are enabled; the rest of the bundle stays off. |
| `which-key.nvim` | Keymap discovery |

Telescope and mini.files split the work: telescope answers "where is X",
mini.files answers "what is around here" and lets you restructure it by editing
the listing as text (`=` to apply).

### Language servers

`lua_ls`, `vtsls`, `html`, `cssls`, `tailwindcss`, `jsonls`, `eslint`.

Install or repair them with `:MasonInstallServers`, a small user command defined
in `lua/plugins/lsp.lua` so that no extra plugin is needed for this.

## Gotchas worth knowing

- **nvim-treesitter is pinned to `branch = "master"`.** Its default branch is now
  `main`, a rewrite that needs Neovim 0.12 nightly. Removing the pin silently
  breaks highlighting on 0.11.
- **Do not define `on_attach` in `after/lsp/eslint.lua`.** Config tables merge
  with `force`, so it would replace nvim-lspconfig's own `on_attach` and destroy
  the `LspEslintFixAll` command. The wrapper in `lua/plugins/lsp.lua` captures
  the base function and calls it first.
- **Images only work outside a multiplexer.** herdr does not forward Kitty
  graphics written into the pty by a child process — verified with raw
  `chafa --format kitty` in a herdr pane, which draws nothing while the same
  command in a plain Ghostty tab works. Critically, herdr *does* relay the
  terminal version query, so `Snacks.image.supports_terminal()` returns true
  there and cannot be used as the gate on its own. `lua/util/graphics.lua` is
  the single predicate; everything else defers to it.

  Practical effect: in a herdr pane you get the generated ASCII mark and
  mini.files shows `-Non-text-file----` for images. In a plain Ghostty or Kitty
  window you get the real PNG on the start page and in the preview pane.
  `:DashboardLogoTier` explains which and why. `vim.g.images_enabled = false`
  turns images off everywhere.
- **chafa in a dashboard `terminal` section can never work**, even where
  graphics do: a terminal section runs inside nvim's own terminal emulator, and
  libvterm swallows graphics escapes instead of forwarding them.
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

The 0.11 native LSP defaults are in play: `grn` rename, `gra` code action,
`grr` references, `gri` implementation, `gO` document symbols, `]d` / `[d`
diagnostics. `lua/plugins/lsp.lua` adds `gd`, `gD`, `gy`, `K`, `<leader>cr`,
`<leader>ca` and `<leader>ch`.
