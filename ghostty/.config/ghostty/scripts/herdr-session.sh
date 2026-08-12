#!/bin/bash

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v herdr >/dev/null; then
    exec "$SHELL"
fi

herdr
exec "$SHELL"
