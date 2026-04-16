# Kanagawa Wave Theme for Nushell
# https://github.com/rebelot/kanagawa.nvim

let kanagawa = {
  wave: {
    # Backgrounds
    bg0: "#16161D"
    bg1: "#1F1F28"
    bg2: "#2A2A37"
    bg3: "#363646"
    bg4: "#54546D"

    # Main colors
    red: "#C34043"
    red2: "#E46876"
    red3: "#FF5D62"
    yellow: "#DCA561"
    yellow2: "#E6C384"
    yellow3: "#C0A36E"
    green: "#98BB6C"
    green2: "#76946A"
    green3: "#6A9589"
    green4: "#7AA89F"
    blue: "#7FB4CA"
    blue2: "#658594"
    blue3: "#7E9CD8"
    blue4: "#9CABCA"
    violet: "#938AA9"
    violet2: "#957FB8"
    violet3: "#D27E99"
    pink: "#D27E99"
    orange: "#FFA066"
    orange2: "#FF9E3B"
    aqua: "#7AA89F"

    # Foreground and grays
    fg: "#DCD7BA"
    fg2: "#C8C093"
    gray: "#727169"
    gray2: "#C8C093"
    gray3: "#938AA9"
    gray4: "#54546D"
    gray5: "#363646"

    # Diff and git
    diffGreen: "#2B3328"
    diffYellow: "#49443C"
    diffRed: "#43242B"
    diffBlue: "#252535"
    gitGreen: "#76946A"
    gitRed: "#C34043"
    gitYellow: "#DCA561"
  }
}

let stheme = $kanagawa.wave

let theme = {
  separator: $stheme.gray4
  leading_trailing_space_bg: $stheme.gray4
  header: $stheme.green
  date: $stheme.violet
  filesize: $stheme.blue3
  row_index: $stheme.violet3
  bool: $stheme.orange
  int: $stheme.orange
  duration: $stheme.orange
  range: $stheme.orange
  float: $stheme.orange
  string: $stheme.green
  nothing: $stheme.orange
  binary: $stheme.orange
  cellpath: $stheme.orange
  hints: $stheme.gray

  shape_garbage: { fg: $stheme.bg0 bg: $stheme.red attr: b }
  shape_bool: $stheme.blue3
  shape_int: { fg: $stheme.violet2 attr: b}
  shape_float: { fg: $stheme.violet2 attr: b}
  shape_range: { fg: $stheme.yellow attr: b}
  shape_internalcall: { fg: $stheme.blue3 attr: b}
  shape_external: { fg: $stheme.blue attr: b}
  shape_externalarg: $stheme.fg
  shape_literal: $stheme.blue3
  shape_operator: $stheme.yellow3
  shape_signature: { fg: $stheme.green attr: b}
  shape_string: $stheme.green
  shape_filepath: $stheme.yellow2
  shape_globpattern: { fg: $stheme.aqua attr: b}
  shape_variable: $stheme.fg
  shape_flag: { fg: $stheme.blue2 attr: b}
  shape_custom: {attr: b}
}
