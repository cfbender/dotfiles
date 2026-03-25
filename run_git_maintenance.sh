#!/bin/sh

for TARGET in ~/code/pdq/* ~/code/github/* ~/code/playground/* ~/.local/share/chezmoi; do
  [ -d "$TARGET" ] || continue

  # loop through targets and append repo = target for maintenance in git config
  git config --global --add maintenance.repo "$TARGET"
done
