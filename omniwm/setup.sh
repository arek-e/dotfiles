#!/usr/bin/env bash
# Copies the OmniWM settings into place. OmniWM rewrites its settings file on
# quit, so this is a copy, not a symlink. The existing file is backed up first.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
target="$HOME/.config/omniwm/settings.toml"
mkdir -p "$(dirname "$target")"
if [ -f "$target" ] && ! cmp -s "$here/.config/omniwm/settings.toml" "$target"; then
  cp "$target" "$target.bak-$(date +%Y%m%d%H%M%S)"
fi
cp "$here/.config/omniwm/settings.toml" "$target"
echo "OmniWM settings installed to $target. Restart OmniWM to apply."
