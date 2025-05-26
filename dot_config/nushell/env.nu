$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend /opt/homebrew/bin
  | append /opt/homebrew/share/google-cloud-sdk/bin
  | append /usr/local/bin
  | append ($env.HOME | path join bin)
  | append ($env.HOME | path join .cargo bin)
  | append ($env.HOME | path join .deno bin)
  | append ($env.HOME | path join go bin)
  | append ($env.HOME | path join .local bin)
  | append ($env.HOME | path join .cabal bin)
  | append ($env.HOME | path join .ghcup bin)
  | uniq # filter so the paths are unique
)

$env.RIPGREP_CONFIG_PATH = ($env.HOME | path join .ripgreprc)

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

let mise_path = $nu.default-config-dir | path join scripts mise.gen.nu
^~/.local/bin/mise activate nu | save --force $mise_path

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

zoxide init nushell | save -f ~/.zoxide.nu

mkdir ~/.local/share/atuin/
atuin init nu | save --force ~/.local/share/atuin/init.nu

$env.config.buffer_editor = "nvim"

jj util completion nushell | save ~/completions-jj.nu
