#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_line() {
  printf '%s\n' "$1"
}

detect_gh() {
  if command -v gh >/dev/null 2>&1; then
    printf '%s\n' "gh"
    return 0
  fi

  if command -v gh.exe >/dev/null 2>&1; then
    printf '%s\n' "gh.exe"
    return 0
  fi

  return 1
}

check_command() {
  local name="$1"

  if [[ "$name" == "gh" ]]; then
    if detect_gh >/dev/null 2>&1; then
      print_line "[ok] gh is available"
      return 0
    fi

    print_line "[missing] gh is not installed or not in PATH"
    return 1
  fi

  if command -v "$name" >/dev/null 2>&1; then
    print_line "[ok] $name is available"
    return 0
  fi

  print_line "[missing] $name is not installed or not in PATH"
  return 1
}

print_line "Bootstrap check for AI Dev Template"
print_line "Repository: $ROOT_DIR"

missing=0

check_command git || missing=1
check_command gh || missing=1

if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  print_line "[ok] repository is a git work tree"
else
  print_line "[missing] repository is not a valid git work tree"
  missing=1
fi

print_line ""
print_line "Next steps:"
print_line "1. Review .ai-dev-template.config.json and adjust workflow policy if needed."
print_line "2. Copy .env.example to .env if optional vector DB may be used."
print_line "3. Run bash scripts/check-environment.sh for a full readiness report."
print_line "4. Run bash scripts/check-github-permissions.sh to inspect token scope baseline."
print_line "5. Create a GitHub Project manually if it does not exist yet."
print_line "6. Give the agent the GitHub Project URL and the business task."

if [[ "$missing" -ne 0 ]]; then
  print_line ""
  print_line "Bootstrap finished with missing prerequisites."
  exit 1
fi

print_line ""
print_line "Bootstrap finished. Continue with bash scripts/check-environment.sh."
