#!/bin/sh

TARGETS=$(ls -d ~/code/pdq/* ~/code/github/* ~/code/playground/*  ~/.local/share/chezmoi)

# loop through targets and append repo = target for maintenance in git config
for TARGET in $TARGETS; do
  git config --global --add maintenance.repo $TARGET
done
