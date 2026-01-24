#!/bin/bash

# =============================================================================
# Dotfiles Update Script
# =============================================================================
# Run from anywhere: ~/dotfiles/update.sh or add alias: alias dotup='~/dotfiles/update.sh'

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() { printf "${BLUE}==>${NC} %s\n" "$1"; }
print_success() { printf "${GREEN}✓${NC} %s\n" "$1"; }
print_warning() { printf "${YELLOW}⚠${NC} %s\n" "$1"; }

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

cd "$DOTFILES_DIR" || { echo "Error: $DOTFILES_DIR not found"; exit 1; }

echo ""
echo "Updating dotfiles..."
echo ""

# Pull latest changes
print_step "Pulling latest changes..."
git pull origin main
print_success "Git updated"

# Update Homebrew packages
if command -v brew &> /dev/null; then
    print_step "Updating Homebrew..."
    brew update && brew upgrade

    print_step "Installing new packages from Brewfile..."
    brew bundle install
    print_success "Packages updated"
fi

# Re-stow all dotfiles
print_step "Re-stowing dotfiles..."
for dir in */; do
    if [ -d "$dir" ] && [ "$dir" != ".git/" ] && [ "$dir" != ".context/" ]; then
        stow -R "${dir%/}" 2>/dev/null || true
    fi
done
print_success "Dotfiles re-stowed"

# Update Oh My Zsh
if [ -d ~/.oh-my-zsh ]; then
    print_step "Updating Oh My Zsh..."
    (cd ~/.oh-my-zsh && git pull origin master 2>/dev/null) || true
    print_success "Oh My Zsh updated"
fi

# Update TPM plugins
if [ -d ~/.tmux/plugins/tpm ]; then
    print_step "Updating Tmux plugins..."
    ~/.tmux/plugins/tpm/bin/update_plugins all 2>/dev/null || true
    print_success "Tmux plugins updated"
fi

echo ""
printf "${GREEN}✓ Dotfiles updated!${NC}\n"
echo ""
echo "Reload shell: exec zsh"
echo ""
