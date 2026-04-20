#!/usr/bin/env bash

set -eu

if [[ "${1:-}" == "--inside" ]]; then
  export ZALLY_HIDE_SESSION="${ZELLIJ_SESSION_NAME:-}"
fi

TARGET=$(tv zally --no-sort) || true

[[ -z "$TARGET" ]] && exit 1

NAME=$(basename "$TARGET")
SESSION_NAME=$(echo "$NAME" | tr '[:lower:]' '[:upper:]')

if [[ -f "$HOME/.config/zellij/layouts/$NAME.kdl" ]]; then
  LAYOUT="$NAME"
else
  LAYOUT="default"
fi

SESSION_EXISTS=false
zellij list-sessions -s 2>/dev/null | grep -qx "$SESSION_NAME" && SESSION_EXISTS=true

# Track last-attached time for sorting
mkdir -p "$HOME/.local/state/zally"
touch "$HOME/.local/state/zally/$SESSION_NAME"

if [[ "${1:-}" == "--inside" ]]; then
  zellij action switch-session "$SESSION_NAME" --cwd "$TARGET" --layout "$LAYOUT"
  exit 0
fi

if $SESSION_EXISTS; then
  zellij attach "$SESSION_NAME"
else
  cd "$TARGET"
  zellij attach "$SESSION_NAME" -c options --default-layout "$LAYOUT"
fi
