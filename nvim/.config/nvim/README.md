# Neovim Configuration

LazyVim-based config optimized for TypeScript fullstack development with tmux integration.

## Features

- **LazyVim** base with TypeScript, JSON, Tailwind, ESLint, Prettier extras
- **Telescope** + fzf-native for fuzzy finding
- **Harpoon 2** for quick file navigation
- **Oil.nvim** + Neo-tree for file exploration
- **Diffview** + Gitsigns for git workflow
- **vim-tmux-navigator** for seamless pane navigation
- **Tokyo Night** theme

## Structure

```
nvim/.config/nvim/
├── init.lua                    # Bootstrap lazy.nvim
├── lua/
│   ├── config/
│   │   ├── lazy.lua            # LazyVim + extras
│   │   ├── options.lua         # Editor options
│   │   ├── keymaps.lua         # Custom keybindings
│   │   └── autocmds.lua        # Autocommands
│   └── plugins/
│       ├── git.lua             # gitsigns + diffview
│       ├── editor.lua          # harpoon + oil + telescope
│       ├── tmux.lua            # vim-tmux-navigator
│       ├── ui.lua              # theme + bufferline + lualine
│       └── lang.lua            # treesitter + autotag
```

## Key Bindings

Leader: `Space`

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate splits/tmux panes |
| `-` | Oil (parent directory) |
| `<leader>a` | Harpoon add |
| `<leader>h` | Harpoon menu |
| `<leader>1-5` | Harpoon file 1-5 |
| `<leader>gd` | Diffview open |
| `<leader>gf` | File history |
| `<leader>tp` | Tmux pane at file dir |
| `<leader>tw` | Tmux window at file dir |

## First Launch

```bash
# Clear old cache (if migrating from NvChad)
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Launch - plugins auto-install
nvim
```

## Credits

- [LazyVim](https://www.lazyvim.org/)
- [Folke's plugins](https://github.com/folke)
