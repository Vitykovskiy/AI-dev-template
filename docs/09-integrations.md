# Integrations

## GitHub Project

- URL: `<paste GitHub Project URL here>`
- Board type: `Kanban`
- Required statuses present: `yes/no`
- Required fields present: `Status`, `Priority`, `Area`

## Environment Variables

| Variable | Required | Purpose | Status |
| --- | --- | --- | --- |

## Tokens And Secrets

| Secret | Where It Lives | Purpose | Status |
| --- | --- | --- | --- |
| `gh` auth token | GitHub CLI auth store | Issues and Project automation | Unknown |

## GitHub Token Scope Baseline

Required scopes:

- `repo`
- `project`

Recommended scopes:

- `read:org`
- `workflow`

Validation note:

- token scopes are necessary but not sufficient;
- repository membership, project write access, and branch protection rules must still be validated separately;
- use `bash scripts/check-github-permissions.sh` to inspect the current `gh` token baseline.

## Integration Status

- GitHub repository access: `Unknown`
- GitHub Project access: `Unknown`

## Setup Notes

- Update this file as integrations are connected.
- Do not store production secrets in committed files.
- If the project uses a separate secret manager, document the reference location here.
