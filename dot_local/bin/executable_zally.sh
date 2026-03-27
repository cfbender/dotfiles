#!/bin/bash

set -eu

# Safely collect existing directories
TARGETS=""
for dir in ~/code/pdq/* ~/code/github/* ~/code/playground/* ~/.local/share/chezmoi; do
  if [[ -d "$dir" ]]; then
    TARGETS+="$dir"$'\n'
  fi
done

# Exit early if nothing was found
[[ -z "$TARGETS" ]] && exit 1

TARGET=$(echo -n "$TARGETS" | gum filter --limit 1 --placeholder 'yee ur last haw' --height 50 --prompt='  ')
NAME=$(basename "$TARGET")
SESSION_NAME=$(echo "$NAME" | tr '[:lower:]' '[:upper:]')

if [[ -f "$HOME/.config/zellij/layouts/$NAME.kdl" ]]; then
  LAYOUT="$NAME"
else
  LAYOUT="default"
fi

zellij delete-session "$SESSION_NAME" 2>/dev/null || true

if [[ "${1:-}" == "--inside" ]]; then
  zellij action switch-session "$SESSION_NAME" --cwd "$TARGET" --layout "$LAYOUT"
  exit 0
else
  cd "$TARGET"
  zellij attach "$SESSION_NAME" -c options --default-layout "$LAYOUT"
  exit 0
fi
