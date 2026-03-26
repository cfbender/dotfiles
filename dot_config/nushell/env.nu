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
  | append ($env.HOME | path join Library pnpm)
  | append /opt/homebrew/opt/coreutils/libexec/gnubin
  | uniq # filter so the paths are unique
)

$env.RIPGREP_CONFIG_PATH = ($env.HOME | path join .ripgreprc)

# Locale settings for consistent Unicode handling
$env.LANG = "en_US.UTF-8"
$env.LANGUAGE = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

zoxide init nushell | save -f ~/.zoxide.nu

mkdir ~/.local/share/atuin/
atuin init nu | save --force ~/.local/share/atuin/init.nu

$env.config.buffer_editor = "nvim"

# jj completions (only generate if jj is available)
if (which jj | is-not-empty) {
  jj util completion nushell | save -f ~/completions-jj.nu
}

$env.OPENCODE_AGENT_SKILLS_SUPERPOWERS_MODE = true

# pnpm
$env.PNPM_HOME = $env.HOME | path join Library pnpm 

ulimit -n 4096

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
