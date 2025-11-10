# My macOS Dotfiles

<div align="center">

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Tmux](https://img.shields.io/badge/tmux-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)

A clean, minimal macOS development environment featuring the **Tokyo Night** theme.

[Features](#-features) • [Installation](#-installation) • [Structure](#-structure) • [Post-Install](#-post-install) • [Screenshots](#-screenshots)

</div>

---

## Features

-  **Consistent Tokyo Night theme** across all tools
-  **Lightning fast** terminal with Kitty
-  **Powerful multiplexer** with Tmux + plugins
-  **Modern text editor** with Neovim (NvChad)
-  **Enhanced shell** with Zsh + Oh My Zsh
-  **Beautiful prompt** with Starship
-  **Smart search** with Ripgrep + FZF
-  **Productivity launcher** with Raycast

## 🛠️ What's Included

| Tool | Purpose |
|------|---------|
| [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal emulator |
| [Tmux](https://github.com/tmux/tmux) | Terminal multiplexer with Tokyo Night theme |
| [Neovim](https://neovim.io/) | Hyperextensible Vim-based text editor |
| [Zsh](https://www.zsh.org/) | Powerful shell with Oh My Zsh framework |
| [Starship](https://starship.rs/) | Fast, customizable prompt |
| [Raycast](https://www.raycast.com/) | Spotlight replacement |
| [Ripgrep](https://github.com/BurntSushi/ripgrep) | Lightning-fast search tool |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |

## Installation

### Quick Install (One Command)

```bash
git clone git@github.com:arek-e/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && make install
```

### Manual Install

```bash
# Clone the repository
git clone git@github.com:arek-e/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the install script
make install
```

The install script will:
1. Install Homebrew (if not already installed)
2. Install all packages from Brewfile
3. Backup existing configurations
4. Symlink dotfiles using GNU Stow
5. Install Tmux Plugin Manager (TPM)
6. Install Oh My Zsh + plugins
7. Configure macOS settings
8. Set Zsh as default shell

## Structure

```
dotfiles/
├── 📄 Brewfile              # Homebrew packages
├── 📄 Makefile              # Installation commands
├── 📄 install.sh            # Setup script
├── 📄 README.md             # This file
│
├── 📁 kitty/                # Kitty terminal config
│   └── .config/kitty/
│       ├── kitty.conf
│       └── tokyo-night-kitty.conf
│
├── 📁 tmux/                 # Tmux config with Tokyo Night
│   └── .config/tmux/
│       └── tmux.conf
│
├── 📁 nvim/                 # Neovim config (NvChad)
│   └── .config/nvim/
│
├── 📁 zsh/                  # Zsh configuration
│   └── .zshrc
│
├── 📁 starship/             # Starship prompt config
│   └── .config/starship.toml
│
├── 📁 neofetch/             # Neofetch system info
│   └── .config/neofetch/
│
├── 📁 ripgrep/              # Ripgrep config
│   └── .ripgreprc
│
└── 📁 raycast/              # Raycast settings
    └── .config/raycast/
```

##  Post-Install

### 1. Restart Terminal
```bash
exec zsh
```

### 2. Install Tmux Plugins
1. Open tmux: `tmux`
2. Press: `Ctrl+Space` then `Shift+I`
3. Wait for plugins to install

### 3. Neovim Setup
1. Open Neovim: `nvim`
2. Plugins will install automatically
3. Restart Neovim

### 4. Configure Git (if needed)
```bash
git config --global user.name "Alexander Eklund"
git config --global user.email "alexander.eklund@cluro.io"
```

## ⌨️ Key Bindings

### Tmux
| Key | Action |
|-----|--------|
| `Ctrl + Space` | Prefix key |
| `Prefix + % ` | Split vertically |
| `Prefix + -` | Split horizontally |
| `Prefix + h/j/k/l` | Navigate panes (Vim-style) |
| `Shift + Left/Right` | Switch windows |
| `Alt + H/L` | Switch windows (Vim-style) |
| `Prefix + r` | Reload config |

### Kitty
| Key | Action |
|-----|--------|
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab |
| `Cmd+Plus/Minus` | Increase/decrease font size |
| `Cmd+0` | Reset font size |

## Update

Update packages and dotfiles:
```bash
make update
```

## Uninstall

Remove all symlinks:
```bash
make clean
```

### Add More Packages
Edit `Brewfile` and run:
```bash
brew bundle install
```

### Modify Zsh Config
Edit `~/.zshrc` or add custom configs to `~/.config/zsh/`

## Requirements

- macOS
- Git
