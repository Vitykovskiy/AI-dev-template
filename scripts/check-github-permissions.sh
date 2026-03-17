#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_PATH="$ROOT_DIR/.ai-dev-template.config.json"
required_scopes=()
recommended_scopes=()
status=0
GH_BIN=""
PYTHON_BIN=""

report_ok() {
  printf '[ok] %s\n' "$1"
}

report_warn() {
  printf '[warn] %s\n' "$1"
}

report_fail() {
  printf '[fail] %s\n' "$1"
  status=1
}

detect_gh() {
  if command -v gh >/dev/null 2>&1; then
    GH_BIN="gh"
    return 0
  fi

  if command -v gh.exe >/dev/null 2>&1; then
    GH_BIN="gh.exe"
    return 0
  fi

  return 1
}

detect_python() {
  if command -v python >/dev/null 2>&1; then
    PYTHON_BIN="python"
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
    return 0
  fi

  return 1
}

load_scopes_from_config() {
  if [[ ! -f "$CONFIG_PATH" ]]; then
    report_fail "missing config file: .ai-dev-template.config.json"
    exit 1
  fi

  if ! detect_python; then
    report_fail "python is required to read GitHub scope settings from .ai-dev-template.config.json"
    exit 1
  fi

  mapfile -t required_scopes < <(
    "$PYTHON_BIN" -c "import json, pathlib; data=json.loads(pathlib.Path(r'$CONFIG_PATH').read_text(encoding='utf-8')); print(*data['github']['required_token_scopes'], sep='\n')" 2>/dev/null
  )

  mapfile -t recommended_scopes < <(
    "$PYTHON_BIN" -c "import json, pathlib; data=json.loads(pathlib.Path(r'$CONFIG_PATH').read_text(encoding='utf-8')); print(*data['github']['recommended_token_scopes'], sep='\n')" 2>/dev/null
  )

  if [[ "${#required_scopes[@]}" -eq 0 ]]; then
    report_fail "unable to load required scopes from .ai-dev-template.config.json"
    exit 1
  fi
}

if ! detect_gh; then
  report_fail "gh CLI is not installed"
  exit 1
fi

load_scopes_from_config

auth_output="$("$GH_BIN" auth status 2>&1)" || {
  report_fail "gh auth status failed"
  exit 1
}

scopes_line="$(printf '%s\n' "$auth_output" | sed -n "s/.*Token scopes: '\(.*\)'/\1/p" | head -n 1)"

if [[ -z "$scopes_line" ]]; then
  report_fail "unable to detect token scopes from gh auth status"
  exit 1
fi

IFS=',' read -r -a raw_scopes <<< "$scopes_line"
normalized_scopes=()
for scope in "${raw_scopes[@]}"; do
  scope="${scope#"${scope%%[![:space:]]*}"}"
  scope="${scope%"${scope##*[![:space:]]}"}"
  scope="${scope#\'}"
  scope="${scope%\'}"
  normalized_scopes+=("$scope")
done

has_scope() {
  local expected="$1"
  local actual

  for actual in "${normalized_scopes[@]}"; do
    if [[ "$actual" == "$expected" ]]; then
      return 0
    fi
  done

  return 1
}

printf 'GitHub token scope check\n'

for scope in "${required_scopes[@]}"; do
  if has_scope "$scope"; then
    report_ok "required scope present: $scope"
  else
    report_fail "missing required scope: $scope"
  fi
done

for scope in "${recommended_scopes[@]}"; do
  if has_scope "$scope"; then
    report_ok "recommended scope present: $scope"
  else
    report_warn "recommended scope missing: $scope"
  fi
done

if "$GH_BIN" repo view --json nameWithOwner >/dev/null 2>&1; then
  report_ok "gh can access the current repository"
else
  report_warn "gh cannot confirm access to the current repository from this directory"
fi

report_warn "repository-level permissions, branch protections, and project write access must still be validated in the target repository"

exit "$status"
