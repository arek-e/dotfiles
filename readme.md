# macOS Developer Dotfiles

<div align="center">

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Neovim](https://img.shields.io/badge/LazyVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Tmux](https://img.shields.io/badge/tmux-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)

A modern, terminal-first development environment featuring **Ghostty**, **Tmux**, **LazyVim**, and curated CLI tools - with **5 switchable themes** and smooth animations.

[Tools](#-tools) | [Installation](#-installation) | [Key Bindings](#-key-bindings) | [Customization](#-customization)

</div>

---

## Tools

### Core Stack

| Tool | Purpose | Why |
|------|---------|-----|
| [Ghostty](https://ghostty.org/) | Terminal | GPU-accelerated, native macOS, built-in splits, Zig-powered |
| [Tmux](https://github.com/tmux/tmux) | Multiplexer | Session persistence, window management, SSH compatible |
| [LazyVim](https://www.lazyvim.org/) | Editor | Pre-configured IDE, lazy-loading, actively maintained |
| [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/) | Shell | Plugin ecosystem, better defaults |
| [Starship](https://starship.rs/) | Prompt | Fast (Rust), cross-shell, informative |

### Modern CLI Replacements

| Tool | Replaces | Why Better |
|------|----------|------------|
| [eza](https://github.com/eza-community/eza) | `ls` | Icons, git status, tree view |
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax highlighting, line numbers |
| [fd](https://github.com/sharkdp/fd) | `find` | 5x faster, simpler syntax |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Fastest grep, .gitignore aware |
| [delta](https://github.com/dandavison/delta) | `diff` | Syntax highlighting, side-by-side |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Learns habits, `z foo` jumps anywhere |
| [dust](https://github.com/bootandy/dust) | `du` | Visual, intuitive disk usage |
| [duf](https://github.com/muesli/duf) | `df` | Beautiful table output |
| [bottom](https://github.com/ClementTsang/bottom) | `htop` | Graphs, modern UI |
| [procs](https://github.com/dalance/procs) | `ps` | Colored, tree view |
| [sd](https://github.com/chmln/sd) | `sed` | Intuitive, no escaping |

### Productivity Tools

| Tool | Purpose | Why |
|------|---------|-----|
| [yazi](https://github.com/sxyazi/yazi) | File manager | Blazing fast (Rust), image preview, vim keys |
| [atuin](https://github.com/atuinsh/atuin) | Shell history | SQLite-backed, fuzzy search, sync across machines |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | Find anything, integrates everywhere |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git UI | Full git workflow in TUI |
| [tldr](https://github.com/tldr-pages/tldr) | Man pages | Practical examples |
| [jless](https://github.com/PaulJuliusMartinez/jless) | JSON viewer | Interactive, collapsible |
| [xh](https://github.com/ducaale/xh) | HTTP client | Like httpie but faster |
| [tokei](https://github.com/XAMPPRocky/tokei) | Code stats | Fast line counting |
| [hyperfine](https://github.com/sharkdp/hyperfine) | Benchmarking | Command timing with stats |
| [gping](https://github.com/orf/gping) | Ping | Visual graph |
| [wtfutil](https://github.com/wtfutil/wtf) | Dashboard | Terminal dashboard for GitHub, Linear, system info |

### Apps

| App | Purpose |
|-----|---------|
| [Raycast](https://www.raycast.com/) | Spotlight replacement |
| [Notion](https://www.notion.so/) | Notes |
| [Bitwarden](https://bitwarden.com/) | Passwords |

---

## Installation

### Quick Install

```bash
# Clone wherever you prefer
git clone git@github.com:arek-e/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
```

### What It Does

1. Installs Homebrew (if needed)
2. Installs all packages from Brewfile
3. Backs up existing configs to `~/.dotfiles_backup_*`
4. Links dotfiles using GNU Stow
5. Installs TPM + Oh My Zsh + plugins
6. Configures git with delta
7. Applies macOS developer settings
8. Creates `~/projects` directory

Works on **fresh macOS** and **existing setups**.

---

## Post-Install

### 1. Restart Terminal
```bash
exec zsh
```

### 2. Install Tmux Plugins
```bash
tmux
# Press: Ctrl+Space then Shift+I
```

### 3. Launch Neovim
```bash
nvim
# Plugins auto-install, wait for LSP servers
```

### 4. Set Up Atuin (Optional)
```bash
atuin register -u <username> -e <email>
atuin import auto
atuin sync
```

### 5. Set Up Dashboard (Optional)
```bash
# GitHub - uses gh CLI (already in Brewfile)
gh auth login

# Linear - authenticate on first run
npx @schpet/linear-cli

# Launch dashboard
dash
```
*Note: Widgets show auth errors gracefully if not configured.*

---

## Key Bindings

> All tools use consistent navigation: `Ctrl+h/j/k/l` moves between panes seamlessly across nvim and tmux.

### Tmux (Prefix: `Ctrl+Space`)

| Key | Action |
|-----|--------|
| **Navigation** | |
| `Ctrl+h/j/k/l` | Navigate panes (works in nvim too) |
| `Prefix + h/j/k/l` | Navigate panes (manual) |
| `Alt+Arrow` | Navigate panes (no prefix) |
| `Shift+Left/Right` | Switch windows |
| `Alt+H` / `Alt+L` | Switch windows |
| **Splits** | |
| `Prefix + \|` | Split vertical (at current path) |
| `Prefix + -` | Split horizontal (at current path) |
| **Copy Mode** (vi-style) | |
| `Prefix + [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy and exit |
| **Other** | |
| `Prefix + r` | Reload config |
| `Prefix + e` | Edit config |

### Neovim (Leader: `Space`)

| Key | Action |
|-----|--------|
| **Navigation** | |
| `Ctrl+h/j/k/l` | Navigate splits/tmux panes |
| `-` | Oil file explorer (parent dir) |
| `<leader>e` | Neo-tree sidebar toggle |
| `<leader>o` | Oil file explorer |
| **Files (Telescope)** | |
| `<leader>ff` | Find files |
| `<leader>fF` | Find files (current dir) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| **Harpoon** | |
| `<leader>a` | Add file to harpoon |
| `<leader>h` | Harpoon menu |
| `<leader>1-5` | Jump to harpoon file 1-5 |
| `[H` / `]H` | Prev/next harpoon file |
| **Git** | |
| `<leader>gd` | Diffview (working tree) |
| `<leader>gD` | Diffview (last commit) |
| `<leader>gm` | Diffview (vs main branch) |
| `<leader>gB` | Branch files vs main (Telescope) |
| `<leader>gf` | File history (current) |
| `<leader>gF` | File history (repo) |
| `<leader>gq` | Close diffview |
| `]h` / `[h` | Next/prev git hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghb` | Blame line |
| **Tmux from Nvim** | |
| `<leader>tp` | New tmux pane (h-split) at file dir |
| `<leader>tP` | New tmux pane (v-split) at file dir |
| `<leader>tw` | New tmux window at file dir |
| **Code/LSP** | |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format |
| **Diagnostics** | |
| `<leader>xx` | Trouble diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `]d` / `[d` | Next/prev diagnostic |
| **AI (Claude Code)** | |
| `<C-,>` | Toggle Claude Code terminal |
| `<leader>ac` | Claude Code |
| `<leader>aC` | Claude Continue |
| `<leader>aR` | Claude Resume (pick session) |
| **UI & Themes** | |
| `<leader>uC` | Switch colorscheme |
| `<leader>z` | Zen mode |
| `<leader>Z` | Zen zoom (fullscreen) |
| `<leader>un` | Notification history |
| `<leader>uD` | Toggle dim (focus scope) |
| `<leader>wf` | Toggle focus mode (golden ratio) |
| `<leader>;` | Dropbar pick (breadcrumb) |
| **Noice (Messages)** | |
| `<leader>snl` | Last message |
| `<leader>snh` | Message history |
| `<leader>snd` | Dismiss all |
| **Editing** | |
| `jk` | Exit insert mode |
| `Ctrl+s` | Save file |
| `Alt+j/k` | Move line down/up |
| `gcc` | Toggle comment |

### Ghostty / Kitty (macOS)

| Key | Action |
|-----|--------|
| `Cmd+d` | Split right |
| `Cmd+Shift+d` | Split down |
| `Cmd+w` | Close pane |
| `Cmd+t` | New tab |
| `Cmd+Shift+[` / `]` | Prev/next tab |
| `Cmd+Shift+Arrow` | Navigate splits |
| `Cmd++` / `-` / `0` | Font size |
| `Cmd+k` | Clear screen |

### Shell (Zsh)

| Key/Command | Action |
|-------------|--------|
| `Up/Down` | History substring search |
| `Ctrl+r` | FZF history search |
| `Ctrl+t` | FZF file finder |
| `z <dir>` | Zoxide smart cd |
| `v` / `vim` | Neovim |
| `lg` | Lazygit |
| `db` / `dash` | WTF dashboard |
| `dev <name>` | Open project in tmux+nvim |

---

## Structure

```
dotfiles/
├── Brewfile              # Packages
├── Makefile              # Commands
├── install.sh            # Setup
│
├── atuin/                # Shell history
├── ghostty/              # Terminal
├── nvim/                 # LazyVim
├── tmux/                 # Multiplexer
├── wtf/                  # Dashboard (GitHub, Linear)
├── yazi/                 # File manager
├── zsh/                  # Shell
├── starship/             # Prompt
├── ripgrep/              # Search
├── neofetch/             # System info
└── raycast/              # Launcher
```

---

## Customization

### Config Shortcuts

| Config | Command |
|--------|---------|
| Zsh | `zshconfig` |
| Neovim | `nvimconfig` |
| Tmux | `tmuxconfig` |
| Ghostty | `ghosttyconfig` |
| Yazi | `yaziconfig` |

### Add Packages

```bash
# Edit Brewfile, then:
brew bundle install
```

### Reload Config

```bash
reload  # or: source ~/.zshrc
```

---

## Maintenance

```bash
make update  # Update everything
make clean   # Remove symlinks
```

---

## Themes

Switch themes in Neovim with `<leader>uC`:

| Theme | Variants | Description |
|-------|----------|-------------|
| **Catppuccin** (default) | mocha, macchiato, frappe, latte | Best plugin support, soothing pastels |
| **TokyoNight** | night, storm, moon, day | Clean dark theme by Folke |
| **Kanagawa** | wave, dragon, lotus | Inspired by Hokusai painting |
| **Rose Pine** | main, moon, dawn | Soho vibes |
| **Nightfox** | nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox | Highly customizable |

### Terminal Theme

- Ghostty: `tokyonight` theme
- Tmux: [catppuccin/tmux](https://github.com/catppuccin/tmux) (matches nvim default)
- Yazi: Custom Tokyo Night
- fzf/bat: Tokyo Night colors

### Visual Enhancements

| Feature | Plugin |
|---------|--------|
| Cursor trail animation | smear-cursor.nvim |
| Mode-aware colors | reactive.nvim |
| Smooth scrolling | snacks.nvim |
| Popup cmdline | noice.nvim |
| Golden ratio windows | focus.nvim |
| Floating filenames | incline.nvim |
| Breadcrumb bar | dropbar.nvim |

## Fonts

Nerd Fonts included:
- **Monaspace** (default) - ligatures + icons
- JetBrains Mono
- Fira Code
- Meslo LG

---

## Requirements

- macOS (Apple Silicon or Intel)
- Git
- Internet

## License

MIT
