# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# ============================================
# Oh My Zsh Plugins
# ============================================
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
  zsh-bat
  zsh-history-substring-search
  tmux                          # NEW: Tmux plugin for Oh My Zsh
  vi-mode                       # NEW: Vi keybindings (optional)
)

source $ZSH/oh-my-zsh.sh

# ============================================
# Editor Configuration
# ============================================
# Set neovim as default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# ============================================
# Tmux Configuration
# ============================================
# Auto-start tmux (optional - comment out if you don't want this)
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi

# Tmux aliases
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# ============================================
# Neovim Aliases
# ============================================
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# ============================================
# Modern CLI Tools
# ============================================
# Use eza instead of ls (if installed)
if command -v eza &> /dev/null; then
  alias ls='eza --icons'
  alias ll='eza -l --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --icons'
fi

# Use bat instead of cat (if installed)
if command -v bat &> /dev/null; then
  alias cat='bat'
  export BAT_THEME="gruvbox-dark"  # or "tokyonight" to match your kitty theme
fi

# Use fd instead of find (if installed)
if command -v fd &> /dev/null; then
  alias find='fd'
fi

# ============================================
# FZF Configuration (fuzzy finder)
# ============================================
if command -v fzf &> /dev/null; then
  # Set up fzf key bindings and fuzzy completion
  source <(fzf --zsh)
  
  # Use fd with fzf
  if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  
  # Use bat for preview
  if command -v bat &> /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
  fi
fi

# ============================================
# Ripgrep Configuration
# ============================================
if command -v rg &> /dev/null; then
  alias grep='rg'
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# ============================================
# NVM Configuration
# ============================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================
# Bun Configuration
# ============================================
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ============================================
# Starship Prompt (keep at end)
# ============================================
eval "$(starship init zsh)"

# ============================================
# Zoxide (smarter cd)
# ============================================
eval "$(zoxide init zsh)"

# ============================================
# Welcome Message
# ============================================
neofetch

# ============================================
# Custom Functions
# ============================================
# Quick edit configs
alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="nvim ~/.config/nvim"
alias tmuxconfig="nvim ~/.tmux.conf"
alias kittyconfig="nvim ~/.config/kitty/kitty.conf"

# Reload zsh config
alias reload="source ~/.zshrc"

# Git shortcuts (enhance the git plugin)
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'

# Tmux + Neovim project opener
function dev() {
  if [ -z "$1" ]; then
    echo "Usage: dev <project-name>"
    return 1
  fi
  
  tmux new-session -d -s "$1"
  tmux send-keys -t "$1" "cd ~/projects/$1 && nvim" C-m
  tmux attach -t "$1"
}
