#!/usr/bin/env bash

set -eu

apply_default_layout() {
  local created=$1
  local workspace_id editor_tab editor_pane

  workspace_id=$(printf '%s' "$created" | jq -r '.result.workspace.workspace_id')
  editor_tab=$(printf '%s' "$created" | jq -r '.result.tab.tab_id')
  editor_pane=$(printf '%s' "$created" | jq -r '.result.root_pane.pane_id')

  herdr tab rename "$editor_tab" " " >/dev/null
  herdr pane run "$editor_pane" nvim >/dev/null
  herdr tab create --workspace "$workspace_id" --cwd "$TARGET" --label " " --no-focus >/dev/null
  herdr tab focus "$editor_tab" >/dev/null
}

apply_houston_layout() {
  local created=$1
  local workspace_id editor_tab editor_pane
  local dev_tab dev_pane dev_right
  local server_tab server_pane agent_tab agent_pane

  workspace_id=$(printf '%s' "$created" | jq -r '.result.workspace.workspace_id')
  editor_tab=$(printf '%s' "$created" | jq -r '.result.tab.tab_id')
  editor_pane=$(printf '%s' "$created" | jq -r '.result.root_pane.pane_id')

  herdr tab rename "$editor_tab" " " >/dev/null
  herdr pane run "$editor_pane" nvim >/dev/null

  dev_tab=$(herdr tab create --workspace "$workspace_id" --cwd "$TARGET" --label "  " --no-focus)
  dev_pane=$(printf '%s' "$dev_tab" | jq -r '.result.root_pane.pane_id')
  dev_right=$(herdr pane split "$dev_pane" --direction right --ratio 0.5 --cwd "$TARGET" --no-focus | jq -r '.result.pane.pane_id')
  herdr pane split "$dev_right" --direction down --ratio 0.5 --cwd "$TARGET" --no-focus >/dev/null
  herdr pane run "$dev_right" "aube -r dev" >/dev/null

  herdr tab create --workspace "$workspace_id" --cwd "$TARGET" --label "󰂓󰙨 " --no-focus >/dev/null

  server_tab=$(herdr tab create --workspace "$workspace_id" --cwd "$TARGET" --label " " --no-focus)
  server_pane=$(printf '%s' "$server_tab" | jq -r '.result.root_pane.pane_id')
  herdr pane split "$server_pane" --direction right --ratio 0.5 --cwd "$TARGET" --no-focus >/dev/null
  herdr pane run "$server_pane" "iex -S mix phx.server" >/dev/null

  agent_tab=$(herdr tab create --workspace "$workspace_id" --cwd "$TARGET" --label "󱚥 " --no-focus)
  agent_pane=$(printf '%s' "$agent_tab" | jq -r '.result.root_pane.pane_id')
  herdr pane run "$agent_pane" "omp --profile work-or" >/dev/null

  herdr tab focus "$editor_tab" >/dev/null
}

ensure_server() {
  local attempts=0

  if herdr workspace list >/dev/null 2>&1; then
    return
  fi

  nohup herdr server >/dev/null 2>&1 </dev/null &
  while ! herdr workspace list >/dev/null 2>&1; do
    attempts=$((attempts + 1))
    if [[ "$attempts" -ge 100 ]]; then
      echo "hally: Herdr server did not start" >&2
      exit 1
    fi
    sleep 0.05
  done
}

TARGET=$(tv hally --no-sort) || true
[[ -z "$TARGET" ]] && exit 1

NAME=$(basename "$TARGET")
STATE_KEY=${TARGET#"$HOME/"}
STATE_KEY=${STATE_KEY//\//__}
mkdir -p "$HOME/.local/state/hally"
touch "$HOME/.local/state/hally/$STATE_KEY"

ensure_server

PANES=$(herdr pane list)
WORKSPACE_ID=$(printf '%s' "$PANES" | jq -r --arg target "$TARGET" '
  [.result.panes[]
    | select(
        .cwd == $target
        or .foreground_cwd == $target
        or ((.cwd // "") | startswith($target + "/"))
        or ((.foreground_cwd // "") | startswith($target + "/"))
      )
    | .workspace_id
  ][0] // empty
')

if [[ -n "$WORKSPACE_ID" ]]; then
  herdr workspace focus "$WORKSPACE_ID" >/dev/null
else
  CREATED=$(herdr workspace create --cwd "$TARGET" --label "$NAME" --focus)
  if [[ "$(printf '%s' "$NAME" | tr '[:upper:]' '[:lower:]')" == "houston" ]]; then
    apply_houston_layout "$CREATED"
  else
    apply_default_layout "$CREATED"
  fi
fi

if [[ "${1:-}" == "--inside" ]]; then
  exit 0
fi

exec herdr
