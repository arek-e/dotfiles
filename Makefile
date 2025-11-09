.PHONY: install update clean help

help:
	@echo "Available commands:"
	@echo "  make install  - Full setup (Homebrew + packages + dotfiles)"
	@echo "  make update   - Update packages and dotfiles"
	@echo "  make clean    - Remove all symlinks"

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
