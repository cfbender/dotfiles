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
set -Ua fish_user_paths $HOME/.mix/escripts

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

set -gx XDG_CONFIG_HOME "$HOME/.config"

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
alias cat "bat --style=header,grid"

# Theme (catppuccin)
set -U fish_color_normal cdd6f4
set -U fish_color_command 89b4fa
set -U fish_color_param f2cdcd
set -U fish_color_keyword f38ba8
set -U fish_color_quote a6e3a1
set -U fish_color_redirection f5c2e7
set -U fish_color_end fab387
set -U fish_color_error f38ba8
set -U fish_color_gray 6c7086
set -U fish_color_selection --background=313244
set -U fish_color_search_match --background=313244
set -U fish_color_operator f5c2e7
set -U fish_color_escape f2cdcd
set -U fish_color_autosuggestion 6c7086
set -U fish_color_cancel f38ba8
set -U fish_color_cwd f9e2af
set -U fish_color_user 94e2d5
set -U fish_color_host 89b4fa
set -U fish_pager_color_progress 6c7086
set -U fish_pager_color_prefix f5c2e7
set -U fish_pager_color_completion cdd6f4
set -U fish_pager_color_description 6c7086

starship init fish | source
