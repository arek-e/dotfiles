# Brewfile - Tmux + Neovim Development Environment
# ============================================
# Core Tools
# ============================================
brew "git"
brew "stow"          # For dotfiles management

# ============================================
# Terminal & Apps
# ============================================
cask "kitty"         # GPU-based terminal emulator
brew "neofetch"      # System info tool
cask "raycast"       # Spotlight replacement

# ============================================
# Tmux & Dependencies
# ============================================
brew "tmux"          # Terminal multiplexer
brew "tpm"           # Tmux Plugin Manager
brew "bash"          # Bash 4.2+ (required for tokyo-night-tmux)
brew "bc"            # Calculator (for netspeed widget)
brew "coreutils"     # GNU core utilities
brew "gawk"          # GNU awk
brew "gsed"          # GNU sed
brew "jq"            # JSON processor (for git widgets)
brew "gh"            # GitHub CLI (for git widgets)
brew "glab"          # GitLab CLI (for git widgets)
brew "nowplaying-cli" # Now playing widget for macOS

# ============================================
# Neovim & Dependencies
# ============================================
brew "neovim"        # Neovim 0.9.0+ (required for NvChad)
# Neovim build prerequisites (if building from source)
brew "ninja"
brew "cmake"
brew "gettext"
brew "curl"

# ============================================
# Language Servers & Tools (for NvChad)
# ============================================
brew "node"          # Required for many LSP servers
brew "python3"       # Python support
brew "rust"          # Rust support (optional)
brew "go"            # Go support (optional)

# Modern CLI tools (enhance the experience)
brew "ripgrep"       # Fast grep (used by Telescope in Neovim)
brew "fd"            # Fast find (used by Telescope)
brew "fzf"           # Fuzzy finder
brew "bat"           # Better cat with syntax highlighting
brew "eza"           # Modern ls replacement
brew "tree"          # Directory tree viewer
brew "lazygit"       # Git TUI (optional but great with Neovim)

# ============================================
# Terminal Enhancements
# ============================================
brew "starship"      # Modern shell prompt
brew "zsh"           # Shell (comes with macOS but good to track)

# ============================================
# Fonts (Nerd Fonts v3+ for tokyo-night-tmux)
# ============================================
cask "font-monaspace-nerd-font"      # Recommended by tokyo-night-tmux
cask "font-noto-sans-symbols-2"      # For segmented digit numbers
cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-meslo-lg-nerd-font"
cask "font-fira-code-nerd-font"

# ============================================
# Optional but Recommended
# ============================================
brew "wget"          # Download tool

# Additional language support (uncomment as needed)
brew "lua"
brew "luajit"
# brew "ruby"
# brew "php"
