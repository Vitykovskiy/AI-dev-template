#!/usr/bin/env bash

set -u

if ! command -v gh >/dev/null 2>&1; then
  printf '[fail] gh CLI is required to manage labels.\n'
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  printf '[fail] gh CLI is not authenticated.\n'
  exit 1
fi

REPO="${1:-}"

if [[ -z "$REPO" ]]; then
  if gh repo view --json nameWithOwner >/dev/null 2>&1; then
    REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
  else
    printf '[fail] unable to detect repository. Pass owner/repo explicitly.\n'
    exit 1
  fi
fi

ensure_label() {
  local name="$1"
  local color="$2"
  local description="$3"

  if gh label create "$name" --repo "$REPO" --color "$color" --description "$description" >/dev/null 2>&1; then
    printf '[ok] created label: %s\n' "$name"
    return 0
  fi

  if gh label edit "$name" --repo "$REPO" --color "$color" --description "$description" >/dev/null 2>&1; then
    printf '[ok] updated label: %s\n' "$name"
    return 0
  fi

  printf '[fail] could not create or update label: %s\n' "$name"
  return 1
}

status=0

ensure_label "type: epic" "5319E7" "Large outcome spanning multiple tasks" || status=1
ensure_label "type: feature" "1D76DB" "New product capability" || status=1
ensure_label "type: bug" "D73A4A" "Defect requiring correction" || status=1
ensure_label "type: task" "0E8A16" "Implementation or maintenance task" || status=1
ensure_label "area: frontend" "FBCA04" "Frontend area" || status=1
ensure_label "area: backend" "BFD4F2" "Backend area" || status=1
ensure_label "area: infra" "C5DEF5" "Infrastructure area" || status=1
ensure_label "area: docs" "7057FF" "Documentation area" || status=1
ensure_label "area: data" "006B75" "Data area" || status=1
ensure_label "priority: high" "B60205" "High priority" || status=1
ensure_label "priority: medium" "D93F0B" "Medium priority" || status=1
ensure_label "priority: low" "0E8A16" "Low priority" || status=1
ensure_label "status: blocked" "000000" "Work is blocked" || status=1
ensure_label "status: needs-info" "EDEDED" "More information is required" || status=1

exit "$status"
