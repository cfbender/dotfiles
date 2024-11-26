$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend /opt/homebrew/bin
  | append /usr/local/bin
  | append ($env.HOME | path join bin)
  | append ($env.HOME | path join .cargo bin)
  | append ($env.HOME | path join go bin)
  | append ($env.HOME | path join .local bin)
  | uniq # filter so the paths are unique
)

$env.RIPGREP_CONFIG_PATH = "~/.ripgreprc"

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

let mise_path = $nu.default-config-dir | path join scripts mise.gen.nu
^~/.local/bin/mise activate nu | save --force $mise_path

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

zoxide init nushell | save -f ~/.zoxide.nu
