# Auto launch tmux
if status is-interactive
and not set -q TMUX
    exec tmux
end

set -x TERM xterm-256color
# Add Nerd Font Support
set -g theme_nerd_fonts yes

function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

set -U fish_user_paths $HOME/.local/bin 

set -U  fish_user_paths ~/bin
set -U fish_user_paths (yarn global bin)

set -x RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

function gunwip
    git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1
end
function gwip
    git add -A
    git rm (git ls-files --deleted) 2>/dev/null
    git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
end

set PATH $HOME/.cargo/bin $PATH

