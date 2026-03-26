#!/bin/bash
# Creates or validates the repository-linked GitHub Project required by the issue-driven workflow.
# Usage:
#   bash scripts/bootstrap-github-project.sh
# Optional environment variables:
#   PROJECT_OWNER=<owner login>            Override the project owner. Defaults to the repository owner.
#   PROJECT_TITLE=<project title>          Override the project title. Defaults to "<repo> Delivery".

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

REPO_JSON="$("$GH_CMD" repo view --json name,nameWithOwner,owner,url)"
REPO_NAME="$(printf '%s' "$REPO_JSON" | python -c "import json,sys; data=json.load(sys.stdin); print(data['name'])")"
REPO_OWNER="$(printf '%s' "$REPO_JSON" | python -c "import json,sys; data=json.load(sys.stdin); print(data['owner']['login'])")"
REPO_NAME_WITH_OWNER="$(printf '%s' "$REPO_JSON" | python -c "import json,sys; data=json.load(sys.stdin); print(data['nameWithOwner'])")"

PROJECT_OWNER="${PROJECT_OWNER:-$REPO_OWNER}"
PROJECT_TITLE="${PROJECT_TITLE:-$REPO_NAME Delivery}"
PROJECT_NUMBER="$("$GH_CMD" project list --owner "$PROJECT_OWNER" --format json --jq ".projects[] | select(.title == \"$PROJECT_TITLE\") | .number" 2>/dev/null || true)"

if [ -z "$PROJECT_NUMBER" ]; then
  PROJECT_NUMBER="$("$GH_CMD" project create --owner "$PROJECT_OWNER" --title "$PROJECT_TITLE" --format json --jq '.number')"
  echo "Created project '$PROJECT_TITLE' (#$PROJECT_NUMBER)."
else
  echo "Using existing project '$PROJECT_TITLE' (#$PROJECT_NUMBER)."
fi

if "$GH_CMD" project link "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --repo "$REPO_NAME_WITH_OWNER" >/dev/null 2>&1; then
  echo "Linked project to repository $REPO_NAME_WITH_OWNER."
else
  echo "Project link already present or could not be changed automatically; continuing with validation."
fi

ensure_single_select_field() {
  local field_name="$1"
  local options="$2"
  local field_match

  field_match="$("$GH_CMD" project field-list "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --format json --jq ".fields[] | select(.name == \"$field_name\") | .name" 2>/dev/null || true)"
  if [ -n "$field_match" ]; then
    echo "Field present: $field_name"
  else
    "$GH_CMD" project field-create "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --name "$field_name" --data-type "SINGLE_SELECT" --single-select-options "$options" >/dev/null
    echo "Created field: $field_name"
  fi
}

ensure_single_select_field "Task Type" "initiative,business_analysis,system_analysis,block_delivery,implementation,deploy,e2e"
ensure_single_select_field "Owner Contour" "business-analyst,system-analyst,frontend,backend,devops,qa-e2e"
ensure_single_select_field "Priority" "high,medium,low"

FIELDS_JSON="$("$GH_CMD" project field-list "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --format json)"

printf '%s' "$FIELDS_JSON" | python - <<'PY'
import json
import sys

expected_fields = {
    "Status": ["Inbox", "Ready", "In Progress", "Blocked", "Waiting for Testing", "Testing", "Waiting for Fix", "In Review", "Done"],
    "Task Type": ["initiative", "business_analysis", "system_analysis", "block_delivery", "implementation", "deploy", "e2e"],
    "Owner Contour": ["business-analyst", "system-analyst", "frontend", "backend", "devops", "qa-e2e"],
    "Priority": ["high", "medium", "low"],
}

payload = json.load(sys.stdin)
field_nodes = payload.get("fields", [])
field_map = {}
for node in field_nodes:
    name = node.get("name")
    if name:
        field_map[name] = node

missing_fields = [name for name in expected_fields if name not in field_map]
if missing_fields:
    print(f"Error: missing required project fields: {', '.join(missing_fields)}", file=sys.stderr)
    sys.exit(1)

for field_name, expected_options in expected_fields.items():
    node = field_map[field_name]
    actual_options = [opt.get("name") for opt in node.get("options", [])]
    missing_options = [opt for opt in expected_options if opt not in actual_options]
    if missing_options:
        print(
            f"Error: field '{field_name}' is missing required options: {', '.join(missing_options)}",
            file=sys.stderr,
        )
        sys.exit(1)
PY

PROJECT_URL="$("$GH_CMD" project view "$PROJECT_NUMBER" --owner "$PROJECT_OWNER" --format json --jq '.url')"
echo "Project URL: $PROJECT_URL"
echo "GitHub Project bootstrap validation passed."
