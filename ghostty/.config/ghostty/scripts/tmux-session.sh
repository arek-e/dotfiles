#!/bin/bash
# Ghostty + Tmux Auto-Session Script
# ===================================
# Automatically attaches to or creates a tmux session
#
# Behavior:
# - If already inside tmux: just run shell (avoid nesting)
# - If tmux session "main" exists: attach to it
# - Otherwise: create new session "main" and attach
# - When tmux exits/detaches: drop into shell (don't close Ghostty)

# Add Homebrew to PATH (needed for tmux, etc.)
if [[ -f /opt/homebrew/bin/brew ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

SESSION_NAME="main"

# Don't nest tmux sessions
if [ -n "$TMUX" ]; then
    exec "$SHELL"
fi

# Check if session exists and attach/create
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux attach-session -t "$SESSION_NAME"
else
    tmux new-session -s "$SESSION_NAME"
fi

# After tmux exits (detach, kill, etc.), drop into shell
exec "$SHELL"
