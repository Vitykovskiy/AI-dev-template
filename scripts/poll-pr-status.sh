#!/bin/bash
# Usage: ./scripts/poll-pr-status.sh <pr-number>
# Polls until the AI reviewer (GitHub App) submits APPROVED or CHANGES_REQUESTED.
# Uses individual reviews instead of reviewDecision — the bot has authorAssociation=NONE
# and GitHub does not count its review toward the overall reviewDecision field.

PR=$1

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
  echo "Install it from https://cli.github.com and run 'gh auth login'." >&2
  exit 1
fi

if [ -z "$PR" ]; then
  echo "Usage: $0 <pr-number>" >&2
  exit 1
fi

while true; do
  status=$("$GH_CMD" pr view "$PR" --json reviews -q '
    .reviews
    | map(select(.state == "APPROVED" or .state == "CHANGES_REQUESTED"))
    | last
    | .state // ""
  ')
  if [ "$status" = "APPROVED" ] || [ "$status" = "CHANGES_REQUESTED" ]; then
    echo "$status"
    exit 0
  fi
  sleep 10
done
