# ============================================
# Repair fpath before anything uses it
# ============================================
# FPATH is exported in this setup, so every child process inherits it. When zsh
# itself is upgraded, a long-running parent (a multiplexer server, an editor, a
# login shell from before the upgrade) keeps handing down an FPATH that still
# points at the previous version's function directory. zsh initialises fpath
# from that inherited value instead of its own compiled default, so
# `_main_complete`, `compinit` and `add-zsh-hook` all become unfindable:
#
#   _main_complete: function definition file not found
#
# Fixing this needs two things: drop entries that no longer exist, and make sure
# the running zsh's own function directory is present.
#
# Deliberately NOT wrapped in a function: inside one, `fpath=(...)` assigns a
# function-local array and never reaches the global, which looks like it works
# and does nothing.
#
# The brew path without a version in it is preferred, because it keeps pointing
# at the current zsh; the versioned Cellar path is the fallback.
for _zfn in \
  /opt/homebrew/share/zsh/functions \
  "/opt/homebrew/Cellar/zsh/${ZSH_VERSION}/share/zsh/functions" \
  "/usr/share/zsh/${ZSH_VERSION}/functions"
do
  [[ -d $_zfn ]] && fpath=("$_zfn" $fpath) && break
done
unset _zfn
# (N-/) keeps only entries that exist and are directories
fpath=(${^fpath}(N-/))
typeset -U fpath   # de-duplicate, keeping the first occurrence

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Load secrets (API keys, tokens - not tracked in git)
[[ -f ~/.secrets ]] && source ~/.secrets

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
# cmux Configuration
# ============================================
export PATH="/Applications/cmux.app/Contents/Resources/bin:$PATH"
alias wpr='worktree-pr'

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
  export BAT_THEME="OneHalfDark"
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

  # Tokyo Night colors for fzf
  export FZF_DEFAULT_OPTS='
    --color=dark
    --color=fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7
    --color=fg+:#c0caf5,bg+:#283457,hl+:#7aa2f7
    --color=info:#e0af68,prompt:#7aa2f7,pointer:#bb9af7
    --color=marker:#9ece6a,spinner:#bb9af7,header:#9ece6a
  '

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
# Atuin (magical shell history)
# ============================================
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# ============================================
# Dashboard & Dotfiles
# ============================================
alias dashboard='wtfutil'
alias db='wtfutil'
alias dotup='~/dotfiles/update.sh'

# Developer dashboard (run manually with 'devfetch')


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

# pnpm / Nx
alias n='pnpm nx'

# Project opener (cmux workspace + nvim)
function dev() {
  if [ -z "$1" ]; then
    echo "Usage: dev <project-name>"
    return 1
  fi
  local cmux="/Applications/cmux.app/Contents/Resources/bin/cmux"
  local ws_id
  ws_id=$($cmux new-workspace --command "cd ~/projects/$1 && exec zsh" 2>&1 | grep -oE '[0-9A-F-]{36}')
  if [[ -n "$ws_id" ]]; then
    $cmux rename-workspace --workspace "$ws_id" "$1"
  fi
}

# Yazi file manager with shell integration (cd to dir on quit)
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

source /Users/alex/.daytona.completion_script.zsh

# opencode
export PATH=/Users/alex/.opencode/bin:$PATH
export PATH="$HOME/bin:$PATH"
eval "$(MAIN_REPO="/Users/alex/code/leya" "/Users/alex/code/leya/bin/worktree" init)"

# qlty completions
[ -s "/opt/homebrew/share/zsh/site-functions/_qlty" ] && source "/opt/homebrew/share/zsh/site-functions/_qlty"

# qlty
export QLTY_INSTALL="$HOME/.qlty"
export PATH="$QLTY_INSTALL/bin:$PATH"

# Volta
export VOLTA_HOME="$HOME/code/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/alex/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
eval "$(direnv hook zsh)"
