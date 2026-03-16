#!/usr/bin/env bash

set -u

required_scopes=("repo" "project")
recommended_scopes=("read:org" "workflow")
status=0
GH_BIN=""

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

if ! detect_gh; then
  report_fail "gh CLI is not installed"
  exit 1
fi

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
