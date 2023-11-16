#!/bin/bash

# Get macOS version information
macos_version=$(sw_vers -productVersion)

# Extract major and minor version components
major_version=$(echo $macos_version | awk -F. '{print $1}')
minor_version=$(echo $macos_version | awk -F. '{print $2}')

# Default package manager
package_manager=""

# Check if macOS version is equal or lower than 10.15
if [ "$major_version" -lt 10 ] || ([ "$major_version" -eq 10 ] && [ "$minor_version" -le 15 ]); then
	echo "macOS version is 10.15 or older."
	package_manager="macports"
else
	echo "macOS version is newer than 10.15."
	package_manager="homebrew"
fi

# Use the $package_manager variable as needed in your script
echo "Using package manager: $package_manager"

# Install Homebrew or MacPorts if using them as the package manager
if [ "$package_manager" = "homebrew" ]; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	install_command="sudo brew install"
elif [ "$package_manager" = "macports" ]; then
	if ! command -v port &>/dev/null; then
		echo "Error: MacPorts is not installed. Please install MacPorts and rerun the script."
		exit 1
	fi
	install_command="sudo port install"
fi

# Check if zsh, git, and wget are installed
if command -v zsh &>/dev/null && command -v git &>/dev/null && command -v wget &>/dev/null; then
	echo -e "ZSH, Git, and Wget are already installed.\n"
else
	# Install zsh, git, and wget using the appropriate package manager
	if $install_command zsh git wget; then
		echo -e "ZSH, Git, and Wget installed.\n"
	else
		echo -e "Please install the following packages first, then try again: zsh, git, wget.\n" && exit 1
	fi
fi

# Install antigen
antigen_file="$HOME/antigen.zsh"
antigen_url="https://git.io/antigen"

if [ ! -e "$antigen_file" ]; then
	echo "Installing antigen..."
	curl -L "$antigen_url" >"$antigen_file"
else
	echo "antigen is already installed "
fi

# Install zoxide if not already installed
if ! command -v zoxide &>/dev/null; then
	echo "Installing zoxide..."
	if $install_command zoxide; then
		echo -e "zoxide installed.\n"
	else
		echo -e "Please install zoxide first, then try again.\n" && exit 1
	fi
else
	echo -e "zoxide is already installed.\n"
fi

if ! command -v fc-cache &>/dev/null; then
	echo "Installing fc-cache..."
	if $install_command fontconfig; then
		echo -e "fc-cache installed.\n"
	else
		echo -e "Please install fontconfig first, then try again.\n" && exit 1
	fi
else
	echo -e "fc-cache is already installed.\n"
fi

# Install Alacritty
if ! command -v alacritty &>/dev/null; then
	echo "Installing Alacritty..."
	if $install_command alacritty; then
		echo -e "Alacritty installed.\n"
	else
		echo -e "Please install Alacritty first, then try again.\n" && exit 1
	fi
else
	echo -e "Alacritty is already installed.\n"
fi

if ! command -v lazygit &>/dev/null; then
	echo "Installing lazygit..."
	if $install_command lazygit; then
		echo -e "lazygit installed.\n"
	else
		echo -e "Please install lazygit first, then try again.\n" && exit 1
	fi
else
	echo -e "lazygit is already installed.\n"
fi

# Install Tmux
if ! command -v tmux &>/dev/null; then
	echo "Installing Tmux..."
	if $install_command tmux; then
		echo -e "Tmux installed.\n"
	else
		echo -e "Please install Tmux first, then try again.\n" && exit 1
	fi
else
	echo -e "Tmux is already installed.\n"
fi

# Install NVM if not already installed
if ! command -v nvm &>/dev/null; then
	echo "Installing NVM..."
	if $install_command curl; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
		source "$HOME/.nvm/nvm.sh"
		echo -e "NVM installed.\n"
	else
		echo -e "Please install curl first, then try again.\n" && exit 1
	fi
else
	echo -e "NVM is already installed.\n"
fi

# Install the latest LTS version of Node.js using NVM
if command -v nvm &>/dev/null; then
	echo "Installing the latest LTS version of Node.js..."
	nvm install --lts
	echo -e "Node.js LTS version installed.\n"
else
	echo -e "NVM is not installed. Please install NVM first.\n" && exit 1
fi

# Display Node.js and NPM versions
if command -v nvm &>/dev/null; then
	echo "Node.js version:"
	node --version
	echo -e "\nNPM version:"
	npm --version
else
	echo -e "NVM is not installed. Please install NVM first.\n" && exit 1
fi

# Install Angular CLI globally
if command -v npm &>/dev/null; then
	echo "Installing Angular CLI..."
	npm install -g @angular/cli
	echo -e "Angular CLI installed globally.\n"
else
	echo -e "NPM is not installed. Please install Node.js and NPM first.\n" && exit 1
fi

# Install Maven
if ! command -v mvn &>/dev/null; then
	echo "Installing Maven..."
	if $install_command maven; then
		echo -e "Maven installed.\n"
	else
		echo -e "Please install Maven first, then try again.\n" && exit 1
	fi
else
	echo -e "Maven is already installed.\n"
fi

# Install Java 17
if ! command -v java &>/dev/null || [ "$(java -version 2>&1 | awk '/version/{print $NF}' | tr -d '\"')" != "17" ]; then
	echo "Installing Java 17..."
	if $install_command openjdk17; then
		echo -e "Java 17 intalled.\n"
	else
		echo -e "Please install Java 17 first, then try again.\n" && exit 1
	fi
else
	echo -e "Java 17 is already installed.\n"
fi

# Install Go
if ! command -v go &>/dev/null; then
	echo "Installing Go..."
	if $install_command golang-go; then
		echo -e "Go installed.\n"
	else
		echo -e "Please install Go first, then try again.\n" && exit 1
	fi
else
	echo -e "Go is already installed.\n"
fi

# Clone dotfiles repository
dotfiles_repo="https://github.com/arek-e/dotfiles.git"
dotfiles_dir="$HOME/git/dotfiles"

if [ ! -d "$dotfiles_dir" ]; then
	echo "Cloning dotfiles repository..."
	git clone "$dotfiles_repo" "$dotfiles_dir"
else
	echo "Dotfiles repository already exists. Skipping clone."
fi

# Install Docker
if ! command -v docker &>/dev/null; then
	echo "Installing Docker..."
	if $install_command docker.io; then
		echo -e "Docker installed.\n"
	else
		echo -e "Please install Docker first, then try again.\n" && exit 1
	fi
else
	echo -e "Docker is already installed.\n"
fi

# Check if ~/.config exists
config_dir="$HOME/.config"
if [ ! -d "$config_dir" ]; then
	echo "Creating ~/.config directory..."
	mkdir "$config_dir"
fi

# Create symlinks for each folder inside dotfiles to ~/.config/
for folder in "$dotfiles_dir"/*; do
	folder_name=$(basename "$folder")
	symlink_path="$config_dir/$folder_name"

	# Create symlink if it doesn't exist
	if [ ! -e "$symlink_path" ]; then
		ln -s "$folder" "$symlink_path"
	fi
done

# Symlink .zshrc directly to the home folder
zshrc_symlink="$HOME/.zshrc"
zshrc_dotfiles="$dotfiles_dir/.zshrc"

# Create symlink if it doesn't exist
if [ ! -e "$zshrc_symlink" ]; then
	ln -s "$zshrc_dotfiles" "$zshrc_symlink"
fi

# Clone fast-syntax-highlighting repository
fsh_repo="https://github.com/zdharma/fast-syntax-highlighting.git"
fsh_dir="$HOME/.config/fsh"

if [ ! -d "$fsh_dir" ]; then
	echo "Cloning fast-syntax-highlighting repository..."
	git clone "$fsh_repo" "$fsh_dir"
else
	echo "fast-syntax-highlighting repository already exists. Skipping clone."
fi

# Copy catppuccin-mocha-ini into the fsh folder
catppuccin_mocha_ini="$dotfiles_dir/catppuccin-mocha.ini"
if [ -f "$catppuccin_mocha_ini" ]; then
	cp "$catppuccin_mocha_ini" "$fsh_dir"
else
	echo "Error: catppuccin-mocha-ini file not found."
	exit 1
fi

# Run fast-theme command
echo "Running fast-theme command..."
fast_theme_command="fast-theme XDG:catppuccin-mocha"
$fast_theme_command

echo "Dotfiles setup completed."

# INSTALL FONTS

echo -e "Installing Nerd Fonts version of Hack, Roboto Mono, DejaVu Sans Mono\n"

wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/
wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.fonts/

fc-cache -fv ~/.fonts

if [[ $1 == "--cp-hist" ]] || [[ $1 == "-c" ]]; then
	echo -e "\nCopying bash_history to zsh_history\n"
	if command -v python &>/dev/null; then
		wget -q --show-progress https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py
		cat ~/.bash_history | python bash-to-zsh-hist.py >>~/.zsh_history
	else
		if command -v python3 &>/dev/null; then
			wget -q --show-progress https://gist.githubusercontent.com/muendelezaji/c14722ab66b505a49861b8a74e52b274/raw/49f0fb7f661bdf794742257f58950d209dd6cb62/bash-to-zsh-hist.py
			cat ~/.bash_history | python3 bash-to-zsh-hist.py >>~/.zsh_history
		else
			echo "Python is not installed, can't copy bash_history to zsh_history\n"
		fi
	fi
else
	echo -e "\nNot copying bash_history to zsh_history, as --cp-hist or -c is not supplied\n"
fi

echo -e "\nSudo access is needed to change default shell\n"

if chsh -s $(which zsh) && /bin/zsh -i -c 'omz update'; then
	echo -e "Installation Successful, exit terminal and enter a new session"
else
	echo -e "Something is wrong"
fi
exit
