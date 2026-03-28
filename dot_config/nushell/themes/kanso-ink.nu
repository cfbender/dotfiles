# Kanso Ink Theme for Nushell
# https://github.com/webhooked/kanso.nvim

let kanso = {
  ink: {
    # Backgrounds
    bg0: "#14171d"
    bg1: "#1f1f26"
    bg2: "#22262D"
    bg3: "#393B44"
    bg4: "#4b4e57"

    # Main colors
    red: "#C34043"
    red2: "#E46876"
    red3: "#c4746e"
    yellow: "#DCA561"
    yellow2: "#E6C384"
    yellow3: "#c4b28a"
    green: "#98BB6C"
    green2: "#87a987"
    green3: "#8a9a7b"
    green4: "#6A9589"
    green5: "#7AA89F"
    blue: "#7FB4CA"
    blue2: "#658594"
    blue3: "#8ba4b0"
    blue4: "#8ea4a2"
    violet: "#938AA9"
    violet2: "#8992a7"
    violet3: "#949fb5"
    pink: "#a292a3"
    orange: "#b6927b"
    orange2: "#b98d7b"
    aqua: "#8ea4a2"

    # Foreground and grays
    fg: "#C5C9C7"
    fg2: "#f2f1ef"
    gray: "#717C7C"
    gray2: "#A4A7A4"
    gray3: "#909398"
    gray4: "#75797f"
    gray5: "#5C6066"

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

let stheme = $kanso.ink

let theme = {
  separator: $stheme.gray4
  leading_trailing_space_bg: $stheme.gray4
  header: $stheme.green
  date: $stheme.violet
  filesize: $stheme.blue
  row_index: $stheme.pink
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
  shape_bool: $stheme.blue
  shape_int: { fg: $stheme.violet attr: b}
  shape_float: { fg: $stheme.violet attr: b}
  shape_range: { fg: $stheme.yellow attr: b}
  shape_internalcall: { fg: $stheme.blue attr: b}
  shape_external: { fg: $stheme.blue3 attr: b}
  shape_externalarg: $stheme.fg
  shape_literal: $stheme.blue
  shape_operator: $stheme.yellow
  shape_signature: { fg: $stheme.green attr: b}
  shape_string: $stheme.green2
  shape_filepath: $stheme.yellow3
  shape_globpattern: { fg: $stheme.aqua attr: b}
  shape_variable: $stheme.fg
  shape_flag: { fg: $stheme.blue2 attr: b}
  shape_custom: {attr: b}
}
