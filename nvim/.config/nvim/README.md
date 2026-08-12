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

- **nvim-treesitter is pinned to `branch = "master"`.** Its default branch is
  `main`, an incompatible rewrite. Removing the pin makes this spec's options
  inert and silently breaks highlighting. `master` is locked upstream but
  verified working on 0.12.4; see the comment in `lua/plugins/treesitter.lua`
  for what migrating to `main` would involve.
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

The 0.11 native LSP defaults are in play: `grn` rename, `gra` code action,
`grr` references, `gri` implementation, `gO` document symbols, `]d` / `[d`
diagnostics. `lua/plugins/lsp.lua` adds `gd`, `gD`, `gy`, `K`, `<leader>cr`,
`<leader>ca` and `<leader>ch`.
