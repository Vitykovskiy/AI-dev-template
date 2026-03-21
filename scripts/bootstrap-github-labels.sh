#!/bin/bash
# Creates required labels for AI Dev Template workflow.
# Safe to re-run: existing labels are skipped without error.
# Usage: bash scripts/bootstrap-github-labels.sh

set -e

GH_CMD=""
if command -v gh &> /dev/null; then
  GH_CMD="gh"
elif command -v gh.exe &> /dev/null; then
  GH_CMD="gh.exe"
elif where.exe gh &> /dev/null 2>&1; then
  GH_CMD="$(where.exe gh 2>/dev/null | head -1)"
elif [ -x "/c/Program Files/GitHub CLI/gh.exe" ]; then
  GH_CMD="/c/Program Files/GitHub CLI/gh.exe"
fi

if [ -z "$GH_CMD" ]; then
  echo "Error: gh CLI is not installed or not in PATH." >&2
  exit 1
fi

create_label() {
  local name="$1"
  local color="$2"
  local description="$3"

  if "$GH_CMD" label create "$name" --color "$color" --description "$description" 2>/dev/null; then
    echo "Created:  $name"
  else
    echo "Skipped:  $name (already exists)"
  fi
}

echo "Creating labels..."

create_label "type: epic"    "3E4B9E" "Large outcome decomposed into features and tasks"
create_label "type: feature" "0075ca" "New capability or enhancement"
create_label "type: bug"     "d73a4a" "Defect with observable impact"
create_label "type: task"    "e4e669" "Atomic delivery task"

create_label "area: frontend" "bfd4f2" "Frontend code or UI"
create_label "area: backend"  "0e8a16" "Backend code or API"
create_label "area: infra"    "5319e7" "Infrastructure or deployment"
create_label "area: docs"     "c5def5" "Documentation"
create_label "area: data"     "f9d0c4" "Data models or migrations"

create_label "priority: high"   "d93f0b" "Must be resolved urgently"
create_label "priority: medium" "fbca04" "Normal priority"
create_label "priority: low"    "c2e0c6" "Low urgency"

create_label "status: blocked"    "b60205" "Cannot proceed without resolution"
create_label "status: needs-info" "d4c5f9" "Awaiting clarification"

echo "Done."
