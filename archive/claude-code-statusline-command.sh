# shellcheck shell=bash

input=$(cat)

model=$(jq -r '.model.id // "unknown"' <<<"$input")
effort=$(jq -r '.effort.level // empty' <<<"$input")
remaining=$(jq -r '.context_window.remaining_percentage // empty' <<<"$input")
seven_day_used=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")
five_hour_used=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")

repo_root=$(git -C "${CLAUDE_CWD:-$(pwd)}" rev-parse --show-toplevel 2>/dev/null || true)
repo=${repo_root##*/}
branch=$(git -C "${CLAUDE_CWD:-$(pwd)}" branch --show-current 2>/dev/null || true)

yellow='\033[33m'
orange='\033[38;5;208m'
green='\033[32m'
blue='\033[34m'
red='\033[31m'
reset='\033[0m'
separator=' · '

parts=()

if [[ -n "$effort" ]]; then
  parts+=("${yellow}${model} ${effort}${reset}")
else
  parts+=("${yellow}${model}${reset}")
fi

if [[ -n "$remaining" ]]; then
  parts+=("${orange}Context $(printf '%.0f' "$remaining")% left${reset}")
fi

if [[ -n "$repo" ]]; then
  parts+=("${green}${repo}${reset}")
fi

if [[ -n "$branch" ]]; then
  parts+=("${blue}${branch}${reset}")
fi

limit_str=""
if [[ -n "$five_hour_used" ]]; then
  five_hour_remaining=$(awk '{printf "%.0f", 100 - $1}' <<<"$five_hour_used")
  limit_str="5h ${five_hour_remaining}%"
fi
if [[ -n "$seven_day_used" ]]; then
  weekly_remaining=$(awk '{printf "%.0f", 100 - $1}' <<<"$seven_day_used")
  if [[ -n "$limit_str" ]]; then
    limit_str="${limit_str} / weekly ${weekly_remaining}%"
  else
    limit_str="weekly ${weekly_remaining}%"
  fi
fi
if [[ -n "$limit_str" ]]; then
  parts+=("${red}${limit_str}${reset}")
fi

output=""
for i in "${!parts[@]}"; do
  if [[ $i -eq 0 ]]; then
    output="${parts[$i]}"
  else
    output="${output}${separator}${parts[$i]}"
  fi
done

printf '%b' "$output"
