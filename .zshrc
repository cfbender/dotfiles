# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
        git 
        zsh-autosuggestions 
        zsh-syntax-highlighting
        direnv
)

source $ZSH/oh-my-zsh.sh

# User configuration

#catppuccin theme
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="code ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh  # This loads NVM

export PATH=${HOME}/.local/bin:$PATH

if [[ $TILIX_ID ]]; then # Fixes Tilix new pane issue
        source /etc/profile.d/vte.sh
fi

export PATH=~/bin:$PATH
export PATH="$(yarn global bin):$PATH"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# FZF config
export FZF_DEFAULT_COMMAND='fd'
export FZF_DEFAULT_OPTS="--reverse --ansi --color=bg+:-1,fg:15,fg+:-1,prompt:6,header:5,pointer:2,hl:3,hl+:3,spinner:05,info:15,border:15"

alias yeehaw=rally.sh

export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export VISUAL="nvim"
export EDITOR="nvim"

alias vconf="nvim ~/.config/nvim/"

alias nup='nvim --headless "+Lazy! sync" +qa'

export XDG_CONFIG_HOME="$HOME/.config"

alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

alias ls='lsd'
alias cat='bat --style=header,grid'

# starship prompt
eval "$(starship init zsh)"

# ssh gpg signing
export GPG_TTY=$(tty)

if [[ ! -z "$SSH_CONNECTION" ]]; then
  export PINENTRY_USER_DATA="USE_CURSES=1"
fi

eval "$(~/.local/bin/mise activate zsh)"

eval "$(zoxide init zsh --cmd cd)"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# bun completions
[ -s "/Users/cfb/.bun/_bun" ] && source "/Users/cfb/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(atuin init zsh)"
alias bup="brew update && brew upgrade"

# this shit don't work because the github CLI is bunk af and won't take a file name 
# it only uses the committed one, so even if you try to replace it on the fly it won't use it
function gpc() {
  if [ -f "./.github/pull_request_template.md" ]; then
      cp ./.github/pull_request_template.md ./.github/pull_request_template.md.bak
      cp ~/.github/pull_request_template.md ./.github/pull_request_template.md
      gh pr create -T pull_request_template.md
      cp ./.github/pull_request_template.md.bak ./.github/pull_request_template.md
      rm ./.github/pull_request_template.md.bak
  else
    if [ ! -d "./.github" ]; then
      mkdir -p ./.github
      cp ~/.github/pull_request_template.md ./.github/pull_request_template.md
      gh pr create -T pull_request_template.md
      rm -rf ./.github
    else
      cp ~/.github/pull_request_template.md ./.github/pull_request_template.md
      gh pr create -T pull_request_template.md
      rm ./.github/pull_request_template.md
    fi
  fi
}

function mt() {
  if [ -z "$1" ]; then
    mix test
  else
    add_test=""

    if rg -q --no-messages "test" -g "test/**/*_test.exs"; then
      add_test="lib/**/*_test.exs"
    fi

    cat -p \
    <(find lib test -type f -iname "*$1*_test.exs" -exec rg "test\s" --vimgrep -s {} \; | cut -d':' -f1,2) \
    <(rg "(test\s|describe\s).*$1" -g "lib/**/*_test.exs" -g "$add_test" --vimgrep -s | cut -d':' -f1,2) \
    | xargs mix test
  fi
}

function mtw() {
  fswatch lib test | mix test --listen-on-stdin --stale
}

source <(pkgx --shellcode)  #docs.pkgx.sh/shellcode

function im() {
  iex -S mix
}

function imp() {
  iex -S mix phx.server
}
