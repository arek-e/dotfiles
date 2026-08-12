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
	@rm -rf ~/.config/starship.toml ~/.config/ghostty ~/.config/herdr/config.toml ~/.config/nvim
	@rm -rf ~/.config/tmux ~/.config/yazi ~/.config/atuin
	@rm -rf ~/.config/neofetch ~/.config/raycast ~/.config/wtf
	@echo "✓ Cleanup done. Run 'make install' now."

install:
	@chmod +x install.sh
	@./install.sh

update:
	@chmod +x update.sh
	@./update.sh

clean:
	@echo "Removing dotfile symlinks..."
	@stow -D */
	@echo "✓ Dotfiles unlinked"
