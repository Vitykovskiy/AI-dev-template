# Integrations

## GitHub Project

- URL: `<paste GitHub Project URL here>`
- Board type: `Kanban`
- Required statuses present: `yes/no`
- Required fields present: `Status`, `Priority`, `Area`

## Environment Variables

| Variable | Required | Purpose | Stage first needed | Status |
| --- | --- | --- | --- | --- |

## Tokens And Secrets

| Secret | Where It Lives | Purpose | Stage first needed | Status |
| --- | --- | --- | --- | --- |
| `gh` auth token | GitHub CLI auth store | Issues and Project automation | `setup` | Unknown |

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
- record actual validation results in this file during `setup`.

## Runtime And External Integrations

Document every external system that matters to delivery, deploy, or e2e validation.

| Integration | Purpose | Stage first needed | Status | Notes |
| --- | --- | --- | --- | --- |
| `<integration>` | `<purpose>` | `<analysis/delivery/deploy/e2e-test>` | `<status>` | `<notes>` |

## Integration Status

- GitHub repository access: `Unknown`
- GitHub Project access: `Unknown`
- Deployment environment access: `Unknown`
- E2E environment readiness: `Unknown`

## Setup Notes

- Update this file as integrations are connected or changed.
- Do not store production secrets in committed files.
- If the project uses a separate secret manager, document the reference location here.
