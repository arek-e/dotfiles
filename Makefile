.PHONY: install update clean cleanup help

help:
	@echo "Available commands:"
	@echo "  make install  - Full setup (Homebrew + packages + dotfiles)"
	@echo "  make update   - Update packages and dotfiles"
	@echo "  make clean    - Remove all symlinks"
	@echo "  make cleanup  - Remove conflicting files before install"

cleanup:
	@echo "Removing conflicting config files..."
	@rm -f ~/.zshrc ~/.ripgreprc
	@rm -rf ~/.config/starship.toml ~/.config/ghostty ~/.config/nvim
	@rm -rf ~/.config/tmux ~/.config/yazi ~/.config/atuin
	@rm -rf ~/.config/neofetch ~/.config/raycast ~/.config/wtf
	@echo "✓ Cleanup done. Run 'make install' now."

install:
	@chmod +x install.sh
	@./install.sh

update:
	@echo "Updating packages..."
	@brew update && brew upgrade && brew bundle install
	@echo "Updating dotfiles..."
	@git pull origin main
	@stow -R */
	@echo "✓ Updated!"

clean:
	@echo "Removing dotfile symlinks..."
	@stow -D */
	@echo "✓ Dotfiles unlinked"
