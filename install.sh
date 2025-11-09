#!/bin/bash

# =============================================================================
# macOS Development Environment Setup Script
# =============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# =============================================================================
# 1. Install Homebrew
# =============================================================================
print_step "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# =============================================================================
# 2. Install packages from Brewfile
# =============================================================================
print_step "Installing packages from Brewfile..."
if [ -f "Brewfile" ]; then
    brew bundle install
    print_success "All packages installed"
else
    print_error "Brewfile not found!"
    exit 1
fi

# =============================================================================
# 3. Backup existing configs
# =============================================================================
print_step "Backing up existing configs..."
backup_dir=~/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)
mkdir -p "$backup_dir"

configs_to_backup=(
    "$HOME/.config/kitty"
    "$HOME/.config/neofetch"
    "$HOME/.config/nvim"
    "$HOME/.config/raycast"
    "$HOME/.config/starship.toml"
    "$HOME/.config/tmux"
    "$HOME/.zshrc"
    "$HOME/.ripgreprc"
)

for config in "${configs_to_backup[@]}"; do
    if [ -e "$config" ] && [ ! -L "$config" ]; then
        print_warning "Backing up $(basename $config)"
        cp -r "$config" "$backup_dir/" 2>/dev/null || true
    fi
done

print_success "Backup complete: $backup_dir"

# =============================================================================
# 4. Setup dotfiles with stow
# =============================================================================
print_step "Setting up dotfiles with GNU Stow..."

for dir in kitty neofetch nvim raycast ripgrep starship tmux zsh; do
    if [ -d "$dir" ]; then
        print_step "Stowing $dir..."
        stow -v -t ~ $dir 2>/dev/null || stow -v --adopt -t ~ $dir
        print_success "$dir stowed"
    fi
done

print_success "All dotfiles stowed"

# =============================================================================
# 5. Install Tmux Plugin Manager (TPM)
# =============================================================================
print_step "Installing Tmux Plugin Manager..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_success "TPM installed"
else
    print_success "TPM already installed"
fi

# =============================================================================
# 6. Install Oh My Zsh
# =============================================================================
print_step "Installing Oh My Zsh..."
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Re-stow zshrc after Oh My Zsh installation
    stow -v -t ~ zsh
    
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh already installed"
fi

# Install zsh plugins
print_step "Installing zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    print_success "zsh-autosuggestions installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    print_success "zsh-syntax-highlighting installed"
fi

# =============================================================================
# 7. Set Zsh as default shell
# =============================================================================
print_step "Setting Zsh as default shell..."
ZSH_PATH=$(which zsh)

# Add zsh to allowed shells if not already there
if ! grep -q "$ZSH_PATH" /etc/shells; then
    print_warning "Adding $ZSH_PATH to /etc/shells (requires sudo)"
    echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

# Change default shell if needed
if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH"
    print_success "Zsh set as default shell: $ZSH_PATH"
else
    print_success "Zsh is already default shell"
fi

# =============================================================================
# 8. macOS settings (optional)
# =============================================================================
print_step "Applying macOS settings..."

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

print_success "macOS settings applied"

# Restart Finder
killall Finder 2>/dev/null || true

# =============================================================================
# Finish
# =============================================================================
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Open tmux and press Ctrl+Space then Shift+I to install plugins"
echo "  3. Open Neovim - plugins should be configured already"
echo ""
echo "Your old configs were backed up to: $backup_dir"
echo ""
echo -e "${BLUE}Happy coding! 🚀${NC}"
