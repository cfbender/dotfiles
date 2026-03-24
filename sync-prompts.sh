#!/bin/sh
set -e

REPO_URL="https://github.com/code-yeongyu/oh-my-openagent.git"
CACHE_DIR="$HOME/.cache/oh-my-openagent"
SCRIPT_SOURCE="$HOME/.local/share/chezmoi/dot_config/opencode/export-prompts.ts"

# Clone or pull
if [ -d "$CACHE_DIR/.git" ]; then
  git -C "$CACHE_DIR" checkout -- . 2>/dev/null || true
  git -C "$CACHE_DIR" clean -fd --quiet 2>/dev/null || true
  git -C "$CACHE_DIR" pull --ff-only --quiet 2>/dev/null || true
else
  git clone --quiet "$REPO_URL" "$CACHE_DIR"
fi

# Copy the script into the clone so relative imports resolve
mkdir -p "$CACHE_DIR/scripts"
cp "$SCRIPT_SOURCE" "$CACHE_DIR/scripts/export-prompts.ts"

# Run with --apply
cd "$CACHE_DIR"
bun scripts/export-prompts.ts --apply
