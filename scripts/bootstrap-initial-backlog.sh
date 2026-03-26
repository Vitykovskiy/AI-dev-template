#!/bin/bash
# Seeds the initial initiative and business-analysis issues required before leaving setup.
# Usage:
#   bash scripts/bootstrap-initial-backlog.sh
# Optional environment variables:
#   INITIATIVE_TITLE=<title>           Override the initiative title.
#   BUSINESS_ANALYSIS_TITLE=<title>    Override the business-analysis title.

set -euo pipefail

GH_CMD=""
if command -v gh >/dev/null 2>&1; then
  GH_CMD="gh"
elif command -v gh.exe >/dev/null 2>&1; then
  GH_CMD="gh.exe"
elif where.exe gh >/dev/null 2>&1; then
  GH_CMD="$(where.exe gh 2>/dev/null | head -1)"
elif [ -x "/c/Program Files/GitHub CLI/gh.exe" ]; then
  GH_CMD="/c/Program Files/GitHub CLI/gh.exe"
fi

if [ -z "$GH_CMD" ]; then
  echo "Error: gh CLI is not installed or not in PATH." >&2
  exit 1
fi

if ! "$GH_CMD" auth status >/dev/null 2>&1; then
  echo "Error: gh CLI is not authenticated. Run 'gh auth login --scopes \"repo,project\"' first." >&2
  exit 1
fi

REPO="$("$GH_CMD" repo view --json nameWithOwner --jq '.nameWithOwner')"
INITIATIVE_TITLE="${INITIATIVE_TITLE:-Initial Initiative}"
BUSINESS_ANALYSIS_TITLE="${BUSINESS_ANALYSIS_TITLE:-Initial Business Analysis}"

find_open_issue_by_label() {
  local label="$1"
  "$GH_CMD" issue list --repo "$REPO" --state open --label "$label" --limit 1 --json number --jq '.[0].number // ""'
}

remove_active_label_from_other_issues() {
  local keep_issue="$1"
  local active_issues

  active_issues="$("$GH_CMD" issue list --repo "$REPO" --state open --label "session: active" --limit 100 --json number --jq '.[].number')"
  if [ -z "$active_issues" ]; then
    return
  fi

  while IFS= read -r issue_number; do
    if [ -n "$issue_number" ] && [ "$issue_number" != "$keep_issue" ]; then
      "$GH_CMD" issue edit "$issue_number" --repo "$REPO" --remove-label "session: active" >/dev/null
      echo "Removed session: active from issue #$issue_number."
    fi
  done <<EOF
$active_issues
EOF
}

create_issue() {
  local title="$1"
  local body_file="$2"
  local issue_url
  shift 2
  issue_url="$("$GH_CMD" issue create --repo "$REPO" --title "$title" --body-file "$body_file" "$@")"
  printf '%s\n' "${issue_url##*/}"
}

INITIATIVE_ISSUE="$(find_open_issue_by_label "task_type: initiative")"
if [ -z "$INITIATIVE_ISSUE" ]; then
  initiative_body="$(mktemp)"
  cat >"$initiative_body" <<EOF
## Goal

Establish the first delivery initiative for this repository so issue-driven work can start from a concrete top-level outcome.

## Workflow Metadata

- task_type: \`initiative\`
- owner_contour: \`business-analyst\`
- parent_initiative: \`none\`
- depends_on: \`none\`
- canonical_inputs:
  - \`docs/00-project-overview.md\`
  - \`docs/01-product-vision.md\`
  - the triggering business request for this repository
- definition_of_ready:
  - setup is complete or close to completion
  - the initial business request exists
- definition_of_done:
  - the initial \`business_analysis\` issue exists
  - the downstream workflow chain can be seeded without improvisation
- project_status: \`Ready\`
EOF
  INITIATIVE_ISSUE="$(create_issue "$INITIATIVE_TITLE" "$initiative_body" --label "task_type: initiative" --label "owner_contour: business-analyst" --label "priority: high")"
  rm -f "$initiative_body"
  echo "Created initiative issue #$INITIATIVE_ISSUE."
else
  echo "Using existing initiative issue #$INITIATIVE_ISSUE."
fi

BUSINESS_ANALYSIS_ISSUE="$(find_open_issue_by_label "task_type: business_analysis")"
if [ -z "$BUSINESS_ANALYSIS_ISSUE" ]; then
  business_body="$(mktemp)"
  cat >"$business_body" <<EOF
## Context And Current Problem

- Current situation: The repository has completed technical setup and now requires the first business-analysis task.
- Pain: Without a seeded \`business_analysis\` issue, the workflow has no valid first operational task.
- Why this matters now: \`issue_driven\` routing must start from a concrete initial issue.

## Target Outcome And Business Value

- Expected result: Produce the first canonical business intake for this repository.
- Business value: The repository can enter \`issue_driven\` and immediately route work into the correct first task.

## Workflow Metadata

- task_type: \`business_analysis\`
- owner_contour: \`business-analyst\`
- parent_initiative: \`#$INITIATIVE_ISSUE\`
- depends_on: \`none\`
- canonical_inputs:
  - \`docs/00-project-overview.md\`
  - \`docs/01-product-vision.md\`
  - \`docs/02-business-requirements.md\`
  - the initial stakeholder request for this repository
- definition_of_ready:
  - the initial initiative exists
  - setup-side workflow assets are prepared
- definition_of_done:
  - users, scenarios, scope, and success expectations are documented
  - exactly one downstream \`system_analysis\` issue is ready to start
- project_status: \`In Progress\`
EOF
  BUSINESS_ANALYSIS_ISSUE="$(create_issue "$BUSINESS_ANALYSIS_TITLE" "$business_body" --label "task_type: business_analysis" --label "owner_contour: business-analyst" --label "priority: high" --label "session: active")"
  rm -f "$business_body"
  echo "Created business-analysis issue #$BUSINESS_ANALYSIS_ISSUE."
else
  "$GH_CMD" issue edit "$BUSINESS_ANALYSIS_ISSUE" --repo "$REPO" --add-label "session: active" >/dev/null
  echo "Using existing business-analysis issue #$BUSINESS_ANALYSIS_ISSUE."
fi

remove_active_label_from_other_issues "$BUSINESS_ANALYSIS_ISSUE"

echo "Initial issue-driven backlog is ready:"
echo "- initiative: #$INITIATIVE_ISSUE"
echo "- business_analysis: #$BUSINESS_ANALYSIS_ISSUE"
