#!/usr/bin/env bash
# Turns off macOS "Switch to Desktop 1-9" (Control+1..9) so OmniWM can use them.
# Backs up the current symbolic hotkeys first. Log out and back in if the keys
# still switch desktops.
set -euo pipefail
backup="$HOME/.symbolichotkeys-backup-$(date +%Y%m%d%H%M%S).plist"
defaults export com.apple.symbolichotkeys "$backup"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
defaults export com.apple.symbolichotkeys - | plutil -convert xml1 -o - - > "$tmp"
python3 - "$tmp" <<'PY'
import plistlib, sys
path = sys.argv[1]
with open(path, "rb") as f:
    d = plistlib.load(f)
hk = d.setdefault("AppleSymbolicHotKeys", {})
for k in range(118, 127):  # "Switch to Desktop 1" .. "9"
    hk[str(k)] = {"enabled": False}
with open(path, "wb") as f:
    plistlib.dump(d, f, fmt=plistlib.FMT_XML)
PY
defaults import com.apple.symbolichotkeys "$tmp"
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
echo "macOS Control+1..9 desktop shortcuts disabled. Backup: $backup"
