# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# ============================================
# Oh My Zsh Plugins
# ============================================
# NOTE: 'zsh-syntax-highlighting' MUST be last.
plugins=(
  git
  you-should-use
  zsh-bat                 # change to 'bat' if OMZ complains; see note below
  zsh-history-substring-search
  tmux
  vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --------------------------------------------
# History Substring Search keybindings
# (map arrows in both emacs & vi insert modes)
# --------------------------------------------
bindkey -M emacs  '^[[A' history-substring-search-up
bindkey -M emacs  '^[[B' history-substring-search-down
bindkey -M viins  '^[[A' history-substring-search-up
bindkey -M viins  '^[[B' history-substring-search-down

# Optional visual tweaks:
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'

# ============================================
# Editor Configuration
# ============================================
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================
# Tmux Configuration
# ============================================
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
# eza instead of ls
if command -v eza &> /dev/null; then
  alias ls='eza --icons'
  alias ll='eza -l --icons'
  alias la='eza -la --icons'
  alias lt='eza --tree --icons'
fi

# bat instead of cat
if command -v bat &> /dev/null; then
  alias cat='bat'
  export BAT_THEME="gruvbox-dark"
fi

# fd instead of find
if command -v fd &> /dev/null; then
  alias find='fd'
fi

# ============================================
# FZF Configuration (fuzzy finder)
# ============================================
if command -v fzf &> /dev/null; then
  # Key bindings & completion from brew-installed fzf (more reliable than process substitution)
  [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  [[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh"   ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"

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
# NVM Configuration (optional)
# ============================================
# If you installed 'nvm' via Homebrew:
# export NVM_DIR="$HOME/.nvm"
# [ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"

# If you manage nvm manually, keep your original lines:
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
# Custom Functions & Shortcuts
# ============================================
alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="nvim ~/.config/nvim"
alias tmuxconfig="nvim ~/.tmux.conf"
alias kittyconfig="nvim ~/.config/kitty/kitty.conf"
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
