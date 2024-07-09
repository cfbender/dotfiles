#!/bin/sh

# credit to @skbolton

set -eu
TARGET=$(ls -d ~/code/pdq/* ~/code/github ~/code/playground | gum filter --limit 1 --placeholder 'yee ur last haw partner' --height 50 --prompt='  ')
NAME=$(basename $TARGET)
SESSION_NAME=$(echo $NAME | tr [:lower:] [:upper:])

if [[ -f "$HOME/.config/smug/$NAME.yml" ]]; then
  smug start $NAME -a
else
  smug start default name=$SESSION_NAME root=$TARGET -a
fi
