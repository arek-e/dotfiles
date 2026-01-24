#!/bin/bash

# =============================================================================
# macOS Development Environment Setup Script
# =============================================================================
# Supports both fresh macOS installs and existing setups
# Tools: Ghostty + Tmux + LazyVim + Modern CLI

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    printf "\n"
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    printf "${CYAN}  %s${NC}\n" "$1"
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_step() {
    printf "${BLUE}==>${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}✗${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

# =============================================================================
print_header "macOS Development Environment Setup"
# =============================================================================

echo ""
echo "This script will install and configure:"
echo "  • Ghostty terminal"
echo "  • Tmux with Tokyo Night theme"
echo "  • Neovim with LazyVim"
echo "  • Modern CLI tools (yazi, atuin, delta, etc.)"
echo "  • Zsh with Oh My Zsh + plugins"
echo "  • Starship prompt"
echo ""

# Detect if this is a fresh install or existing setup
FRESH_INSTALL=false
if ! command -v brew &> /dev/null; then
    FRESH_INSTALL=true
    print_warning "Fresh install detected - Homebrew not found"
else
    print_success "Existing setup detected - Homebrew found"
fi

# =============================================================================
print_header "1. Installing Homebrew"
# =============================================================================

if ! command -v brew &> /dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
    print_step "Updating Homebrew..."
    brew update
fi

# =============================================================================
print_header "2. Installing Packages from Brewfile"
# =============================================================================

print_step "Installing all packages (this may take a while)..."
if [ -f "Brewfile" ]; then
    brew bundle install
    print_success "All packages installed"
else
    print_error "Brewfile not found!"
    exit 1
fi

# =============================================================================
print_header "3. Backing Up Existing Configs"
# =============================================================================

print_step "Creating backup of existing configs..."
backup_dir=~/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)
mkdir -p "$backup_dir"

configs_to_backup=(
    "$HOME/.config/ghostty"
    "$HOME/.config/neofetch"
    "$HOME/.config/nvim"
    "$HOME/.config/raycast"
    "$HOME/.config/starship.toml"
    "$HOME/.config/tmux"
    "$HOME/.config/yazi"
    "$HOME/.config/atuin"
    "$HOME/.config/wtf"
    "$HOME/.zshrc"
    "$HOME/.ripgreprc"
)

backup_count=0
for config in "${configs_to_backup[@]}"; do
    if [ -e "$config" ] && [ ! -L "$config" ]; then
        print_warning "Backing up $(basename $config)"
        cp -r "$config" "$backup_dir/" 2>/dev/null || true
        ((backup_count++))
    fi
done

if [ $backup_count -gt 0 ]; then
    print_success "Backed up $backup_count configs to: $backup_dir"
else
    print_success "No existing configs to backup"
fi

# =============================================================================
print_header "4. Setting Up Dotfiles with GNU Stow"
# =============================================================================

print_step "Creating ~/.config directory..."
mkdir -p ~/.config

# List of directories to stow
stow_dirs=(
    "atuin"
    "ghostty"
    "neofetch"
    "nvim"
    "raycast"
    "ripgrep"
    "starship"
    "tmux"
    "wtf"
    "yazi"
    "zsh"
)

for dir in "${stow_dirs[@]}"; do
    if [ -d "$dir" ]; then
        print_step "Stowing $dir..."
        # Remove existing symlinks or directories that would conflict
        if [ -L "$HOME/.config/$dir" ]; then
            rm "$HOME/.config/$dir"
        fi
        stow -v -t ~ "$dir" 2>/dev/null || stow -v --adopt -t ~ "$dir"
        print_success "$dir configured"
    fi
done

print_success "All dotfiles linked"

# =============================================================================
print_header "5. Installing Tmux Plugin Manager (TPM)"
# =============================================================================

if [ ! -d ~/.tmux/plugins/tpm ]; then
    print_step "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    print_success "TPM installed"
else
    print_step "Updating TPM..."
    cd ~/.tmux/plugins/tpm && git pull origin master
    cd - > /dev/null
    print_success "TPM updated"
fi

# =============================================================================
print_header "6. Installing Oh My Zsh"
# =============================================================================

if [ ! -d ~/.oh-my-zsh ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Re-stow zshrc after Oh My Zsh installation (it creates its own)
    rm -f ~/.zshrc
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

# zsh-history-substring-search
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CUSTOM/plugins/zsh-history-substring-search
    print_success "zsh-history-substring-search installed"
fi

# you-should-use
if [ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]; then
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
    print_success "you-should-use installed"
fi

# zsh-bat
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]; then
    git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
    print_success "zsh-bat installed"
fi

# =============================================================================
print_header "7. Configuring Shell"
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
    print_success "Zsh set as default shell"
else
    print_success "Zsh is already default shell"
fi

# =============================================================================
print_header "8. Setting Up Git (Delta Integration)"
# =============================================================================

print_step "Configuring git to use delta..."

# Only set delta config if not already configured
if ! git config --global core.pager 2>/dev/null | grep -q "delta"; then
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle "diff3"
    git config --global diff.colorMoved "default"
    print_success "Git configured with delta"
else
    print_success "Git already configured with delta"
fi

# =============================================================================
print_header "9. Configuring macOS Settings"
# =============================================================================

print_step "Applying developer-friendly macOS settings..."

# Finder settings
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keyboard settings
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"

print_success "macOS settings applied"

# Restart Finder to apply changes
killall Finder 2>/dev/null || true

# =============================================================================
print_header "10. Creating Project Directories"
# =============================================================================

print_step "Creating ~/projects directory..."
mkdir -p ~/projects
print_success "Project directory ready"

# =============================================================================
print_header "Setup Complete!"
# =============================================================================

printf "\n"
printf "${GREEN}═══════════════════════════════════════════════════════════════${NC}\n"
printf "${GREEN}                    Installation Complete!                      ${NC}\n"
printf "${GREEN}═══════════════════════════════════════════════════════════════${NC}\n"
printf "\n"
printf "${CYAN}Next Steps:${NC}\n"
printf "\n"
printf "  1. ${YELLOW}Restart your terminal${NC} or run: ${GREEN}exec zsh${NC}\n"
printf "\n"
printf "  2. ${YELLOW}Install Tmux plugins:${NC}\n"
printf "     • Open tmux: ${GREEN}tmux${NC}\n"
printf "     • Press: ${GREEN}Ctrl+Space${NC} then ${GREEN}Shift+I${NC}\n"
printf "\n"
printf "  3. ${YELLOW}Launch Neovim:${NC}\n"
printf "     • Run: ${GREEN}nvim${NC}\n"
printf "     • Plugins will install automatically\n"
printf "     • Wait for LSP servers to download\n"
printf "\n"
printf "  4. ${YELLOW}Set up Atuin (optional - for history sync):${NC}\n"
printf "     • Register: ${GREEN}atuin register -u <username> -e <email>${NC}\n"
printf "     • Import history: ${GREEN}atuin import auto${NC}\n"
printf "     • Sync: ${GREEN}atuin sync${NC}\n"
printf "\n"
printf "  5. ${YELLOW}Try your new tools:${NC}\n"
printf "     • File manager: ${GREEN}y${NC} (yazi)\n"
printf "     • Git UI: ${GREEN}lg${NC} (lazygit)\n"
printf "     • System monitor: ${GREEN}btm${NC} (bottom)\n"
printf "\n"
if [ $backup_count -gt 0 ]; then
    printf "${YELLOW}Your old configs were backed up to:${NC}\n"
    printf "  %s\n" "$backup_dir"
    printf "\n"
fi
printf "${BLUE}Happy coding!${NC}\n"
printf "\n"
