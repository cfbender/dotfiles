export def mt [pattern?: string] {
    if $pattern == null { mix test } else {
        let test_files = ls lib/**/* test/**/* | where {|f| $f.name =~ $".*($pattern).*_test.exs" } | get name
        let test_lines = ls lib/**/*_test.exs | where {|f| (open $f.name) =~ $pattern } | each { |f|
        open $f.name | lines | enumerate |
        where { $in.item =~ ('(test\s|describe\s).*' ++ $pattern) } |
        each  { $"($f.name):($in.index + 1)" }
      } | flatten
        $test_files ++ $test_lines | mix test ...$in
    }
}
export def mtw [] {
    fswatch lib test | mix test --listen-on-stdin --stale
}
alias im = iex -S mix
alias imp = iex -S mix phx.server
alias yeehaw = zally.sh
export def gunwip [] {
    git log -n 1 | grep -q -c '\--wip--'
    git reset HEAD~1
}
export def gwip [] {
    git add -A
    git ls-files --deleted | git rm err> /dev/null | git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
}
alias pn = pnpm
export def gr [] {
    let current = git rev-parse --abbrev-ref HEAD
    let branch = git reflog | egrep -io "moving from ([^[:space:]]+)" | awk '{ print $3 }' | awk ' !x[$0]++' | egrep -v '^[a-f0-9]{40}$' | head -n 100 | lines | where {|b| $b != $current } | str join (
    # extract 3rd column
    # Removes duplicates.  See http://stackoverflow.com/questions/11532157
    # remove hash results
    char newline) | gum filter --limit 1 --placeholder 'select recent' --height 50
    git sw $branch
}
export def gd [] {
    git diff | diffnav
}
export def gdp [] {
    gh pr diff | diffnav
}
export def gss [] {
    gt sync
    gt submit --stack --update-only
}
export def nup [] { nvim --headless +AstroUpdate +MasonToolsUpdateSync +qa }
export def bup [] {
    brew update
    brew upgrade --cask --greedy
}
export def pup [] {
    sudo pacman -Syu
    paru -Syu
}
export def aup [] {
    sudo apt update
    sudo apt upgrade -y
}
export def fup [] {
    # Pre-authenticate sudo so par-each threads can use cached credentials
    sudo -v
    [1, 2, 3] | par-each { |x| 
    if $x == 1 { 
      echo "Updating neovim dependencies ..." | gum style --foreground "#40a02b" --bold
      nup
    } else if $x == 2 {
      let package_manager = if (which brew | is-not-empty) {
        "brew"
      } else if (which pacman | is-not-empty) {
        "pacman"
      } else if (which apt | is-not-empty) {
        "apt"
      } else {
        null
      }

      if $package_manager == "brew" {
        echo "Updating homebrew packages ..." | gum style --foreground "#df8e1d" --bold
        bup
      } else if $package_manager == "pacman" {
        echo "Updating pacman packages..." | gum style --foreground "#df8e1d" --bold
        pup
      } else if $package_manager == "apt" {
        echo "Updating apt packages..." | gum style --foreground "#df8e1d" --bold
        aup
      } else {
        echo "Skipping system package update (no brew/pacman/apt found)." | gum style --foreground "#d20f39" --bold
      }
    } else {
      echo "Updating mise tools ..." | gum style --foreground "#209fb5" --bold
      mise up
    }
  }
    echo "All done! 🎉" | gum style --foreground 212 --bold
}
