#!/bin/bash
# Creates required labels for AI Dev Template workflow.
# Safe to re-run: required labels are created or updated, legacy labels are removed.
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

ensure_label() {
  local name="$1"
  local color="$2"
  local description="$3"

  if "$GH_CMD" label create "$name" --color "$color" --description "$description" 2>/dev/null; then
    echo "Created:  $name"
  else
    "$GH_CMD" label edit "$name" --color "$color" --description "$description" >/dev/null
    echo "Updated:  $name"
  fi
}

delete_label_if_present() {
  local name="$1"

  if "$GH_CMD" label delete "$name" --yes >/dev/null 2>&1; then
    echo "Deleted:  $name"
  else
    echo "Skipped:  $name (not present)"
  fi
}

echo "Creating labels..."

ensure_label "task_type: initiative"         "3E4B9E" "Top-level delivery outcome and decomposition anchor"
ensure_label "task_type: business_analysis"  "1D76DB" "Clarifies business problem, users, and scope"
ensure_label "task_type: system_analysis"    "5319E7" "Produces canonical implementation-ready specifications"
ensure_label "task_type: block_delivery"     "0E8A16" "Parent issue for one integrated deliverable"
ensure_label "task_type: implementation"     "FBCA04" "Contour-owned child implementation task"
ensure_label "task_type: deploy"             "BFDADC" "Rolls validated outputs into a target environment"
ensure_label "task_type: e2e"                "C2E0C6" "Integrated validation task"
ensure_label "type: bug"                     "D73A4A" "Defect requiring correction"

ensure_label "owner_contour: business-analyst" "C5DEF5" "Owned by the business-analyst contour"
ensure_label "owner_contour: system-analyst"   "BFD4F2" "Owned by the system-analyst contour"
ensure_label "owner_contour: frontend"         "7057FF" "Owned by the frontend contour"
ensure_label "owner_contour: backend"          "0E8A16" "Owned by the backend contour"
ensure_label "owner_contour: devops"           "D4C5F9" "Owned by the devops contour"
ensure_label "owner_contour: qa-e2e"           "F9D0C4" "Owned by the qa-e2e contour"

ensure_label "priority: high"                "D93F0B" "Must be resolved urgently"
ensure_label "priority: medium"              "FBCA04" "Normal priority"
ensure_label "priority: low"                 "C2E0C6" "Low urgency"

delete_label_if_present "type: epic"
delete_label_if_present "type: feature"
delete_label_if_present "type: task"
delete_label_if_present "area: frontend"
delete_label_if_present "area: backend"
delete_label_if_present "area: infra"
delete_label_if_present "area: docs"
delete_label_if_present "area: data"
delete_label_if_present "status: blocked"
delete_label_if_present "status: needs-info"

echo "Done."
