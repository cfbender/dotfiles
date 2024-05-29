#!/bin/sh

set -eu
TARGET=$(ls -d ~/code/pdq/* ~/code/github/*  ~/code/playground/* ~/.config/* | fzf --header-first --header="Launch Project" --preview "eza --color=always --tree --icons --level 3 --git-ignore {}")
NAME=$(basename $TARGET)
SESSION_NAME=$(echo $NAME)

if [[ -f "$HOME/.config/smug/$NAME.yml" ]]; then
  smug start $NAME -a
else
  smug start default name=$SESSION_NAME root=$TARGET -a
fi
