# shellcheck shell=bash

input=$(cat)
event=$(jq -r '.hook_event_name // ""' <<<"$input")
project=$(jq -r '.cwd // "" | split("/") | last // "Claude Code"' <<<"$input")
session=$(jq -r '.session_id // "unknown"' <<<"$input")

case "$event" in
Stop)
  title="Claude Code • 完了"
  body=$(jq -r '
    .last_assistant_message // "タスクが完了しました"
    | gsub("[[:space:]]+"; " ")
    | if length > 240 then .[:237] + "..." else . end
  ' <<<"$input")
  sound="Glass"
  urgency="normal"
  icon="dialog-information"
  ;;
PermissionRequest)
  title="Claude Code • 承認が必要"
  tool=$(jq -r '.tool_name // "ツール"' <<<"$input")
  description=$(jq -r '
    .tool_input.description // .tool_input.file_path // empty
    | gsub("[[:space:]]+"; " ")
    | if length > 180 then .[:177] + "..." else . end
  ' <<<"$input")
  body="${tool} の実行許可を待っています"
  if [[ -n "$description" ]]; then
    body="$body — $description"
  fi
  sound="Ping"
  urgency="critical"
  icon="dialog-warning"
  ;;
*)
  exit 0
  ;;
esac

if [[ "$(uname -s)" == "Darwin" ]]; then
  activate="com.mitchellh.ghostty"
  if [[ "${TERM_PROGRAM:-}" == "vscode" || -n "${VSCODE_GIT_IPC_HANDLE:-}" ]]; then
    activate="com.vscodium"
  elif [[ "${TERMINAL_EMULATOR:-}" == "JetBrains-JediTerm" ]]; then
    activate="com.jetbrains.pycharm"
  elif [[ "${TERM_PROGRAM:-}" == "WarpTerminal" || -n "${WARP_IS_LOCAL_SHELL_SESSION:-}" ]]; then
    activate="dev.warp.Warp-Stable"
  elif [[ "${TERM_PROGRAM:-}" == "Apple_Terminal" ]]; then
    activate="com.apple.Terminal"
  elif [[ "${TERM_PROGRAM:-}" == "iTerm.app" ]]; then
    activate="com.googlecode.iterm2"
  fi

  terminal-notifier \
    -title "$title" \
    -subtitle "$project" \
    -message "$body" \
    -sound "$sound" \
    -group "claude-code-$session" \
    -activate "$activate"
else
  notify-send \
    --app-name="Claude Code" \
    --urgency="$urgency" \
    --icon="$icon" \
    --category="development" \
    "$title" "$project\n$body"
fi
