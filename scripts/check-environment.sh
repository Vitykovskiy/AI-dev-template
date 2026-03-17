#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATUS=0
GH_BIN=""

report_ok() {
  printf '[ok] %s\n' "$1"
}

report_warn() {
  printf '[warn] %s\n' "$1"
}

report_fail() {
  printf '[fail] %s\n' "$1"
  STATUS=1
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

require_file() {
  local file="$1"
  if [[ -f "$ROOT_DIR/$file" ]]; then
    report_ok "found $file"
  else
    report_fail "missing required file: $file"
  fi
}

printf 'Environment check for %s\n' "$ROOT_DIR"

if command -v git >/dev/null 2>&1; then
  report_ok "git is installed"
else
  report_fail "git is not installed"
fi

if command -v python >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1; then
  report_ok "python is installed"
else
  report_warn "python is not installed; scripts/check-github-permissions.sh may not work"
fi

if git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  report_ok "repository is a git work tree"
else
  report_fail "directory is not a git repository"
fi

remote_name="$(git -C "$ROOT_DIR" remote 2>/dev/null | head -n 1)"
if [[ -n "$remote_name" ]]; then
  report_ok "git remote detected: $remote_name"
else
  report_fail "no git remote configured"
fi

git_user_name="$(git -C "$ROOT_DIR" config --get user.name || true)"
git_user_email="$(git -C "$ROOT_DIR" config --get user.email || true)"

if [[ -n "$git_user_name" ]]; then
  report_ok "git user.name is set"
else
  report_warn "git user.name is not set in this repository"
fi

if [[ -n "$git_user_email" ]]; then
  report_ok "git user.email is set"
else
  report_warn "git user.email is not set in this repository"
fi

if detect_gh; then
  report_ok "gh CLI is installed"
  if "$GH_BIN" auth status >/dev/null 2>&1; then
    report_ok "gh auth status succeeded"
  else
    report_fail "gh is installed but not authenticated"
  fi
else
  report_fail "gh CLI is not installed"
fi

if [[ -n "$GH_BIN" ]]; then
  if "$GH_BIN" repo view --json nameWithOwner >/dev/null 2>&1; then
    report_ok "gh can access the current repository"
  else
    report_fail "gh cannot access the current repository"
  fi
fi

require_file "AGENTS.md"
require_file "README.md"
require_file ".ai-dev-template.config.json"
require_file ".env.example"
require_file "docker-compose.vector-db.yml"
require_file "docs/00-project-overview.md"
require_file "docs/07-workflow.md"
require_file "docs/08-vector-db.md"
require_file "docs/11-workflow-configuration.md"
require_file "scripts/bootstrap.sh"
require_file "scripts/check-github-permissions.sh"
require_file "scripts/setup-labels.sh"

if grep -Fq '<paste GitHub Project URL here>' "$ROOT_DIR/docs/09-integrations.md"; then
  report_warn "GitHub Project URL is still a placeholder in docs/09-integrations.md"
else
  report_ok "GitHub Project URL is documented"
fi

printf '\nSummary: '
if [[ "$STATUS" -eq 0 ]]; then
  printf 'environment is ready for agent-driven project setup.\n'
else
  printf 'fix the failed checks before relying on full automation.\n'
fi

exit "$STATUS"
