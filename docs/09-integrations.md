# Integrations

## GitHub Project

- URL: `<paste GitHub Project URL here>`
- Board type: `Kanban`
- Required statuses present: `Inbox`, `Ready`, `In Progress`, `Blocked`, `In Review`, `Done`
- Required fields present: `Status`, `Task Type`, `Owner Contour`, `Priority`
- Project item creation verified: `yes/no`
- Setup validation status: `Unknown`
- Notes: If `project_tracking = github_project`, this project must exist before `setup` can be considered complete.

## GitHub Issues

- Initiative creation verified: `yes/no`
- Task issue creation verified: `yes/no`
- Dependency linking verified: `yes/no`
- Labels prepared for workflow use: `yes/no`
- Required task types available: `initiative`, `business_analysis`, `system_analysis`, `design`, `implementation`, `deploy`, `e2e`
- Notes: Record the identifiers or URLs needed to prove that workflow-required issue records exist and can be linked to project items.

## Environment Variables

| Variable | Required | Purpose | Task type first needed | Status |
| --- | --- | --- | --- | --- |

## Tokens And Secrets

| Secret | Where It Lives | Purpose | Task type first needed | Status |
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
- record actual validation results in this file during `setup`;
- do not report setup or later GitHub-side workflow steps complete until the corresponding side effects are verified, not merely attempted.

## Runtime And External Integrations

Document every external system that matters to analysis, implementation, deploy, or e2e validation.

| Integration | Purpose | Task type first needed | Status | Notes |
| --- | --- | --- | --- | --- |
| `<integration>` | `<purpose>` | `<business_analysis/system_analysis/design/implementation/deploy/e2e>` | `<status>` | `<notes>` |

## Integration Status

- GitHub repository access: `Unknown`
- GitHub Project access: `Unknown`
- Deployment environment access: `Unknown`
- E2E environment readiness: `Unknown`

## Setup Notes

- Update this file as integrations are connected or changed.
- During `setup`, validate GitHub Issues access and GitHub Project access, and record the actual result here.
- Record verification evidence for the GitHub operating model prepared in `setup`, including project readiness, issue creation ability, dependency linking, and required labels or project fields.
- Do not store production secrets in committed files.
- If the project uses a separate secret manager, document the reference location here.
