$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin' | append "~/bin" | append "~/.local/bin" | append "~/.ripgreprc")

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

let mise_path = $nu.default-config-dir | path join scripts mise.gen.nu
^~/.local/bin/mise activate nu | save --force $mise_path
