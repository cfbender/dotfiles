# Auto launch tmux
#if status is-interactive
#and not set -q TMUX
    #exec tmux
#end

# Remove default fish greeting
set -U fish_greeting ""

# Add Nerd Font Support
set -g theme_nerd_fonts yes

# Set firefox as browser
set -x BROWSER firefox.desktop

function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end
set -Ua fish_user_paths (yarn global bin) 
set -Ua fish_user_paths $HOME/.cargo/bin
set -Ua fish_user_paths $HOME/.gem/ruby/2.7.0/bin

set DENO_INSTALL "$HOME/.deno"
set -Ua fish_user_paths $DENO_INSTALL/bin

function dr 
  if test (count $argv) -gt 0
    deno run --allow-read $argv
  else
    deno run --allow-read ./index.ts
  end
end

set -x RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

set --universal FZF_DEFAULT_COMMAND 'fd'

set -gx LANGUAGE "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

set -gx VISUAL nvim
set -gx EDITOR nvim

thefuck --alias | source

function gunwip
    git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1
end
function gwip
    git add -A
    git rm (git ls-files --deleted) 2>/dev/null
    git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
end

alias ls "lsd"
# Nord fish colors
set -U fish_color_normal normal
set -U fish_color_command 81a1c1
set -U fish_color_quote a3be8c
set -U fish_color_redirection b48ead
set -U fish_color_end 88c0d0
set -U fish_color_error ebcb8b
set -U fish_color_param eceff4
set -U fish_color_comment 434c5e
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 4c566a
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan

