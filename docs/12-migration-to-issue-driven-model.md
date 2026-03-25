# Migration To Issue-Driven Model

## Purpose

This file describes how repositories using the old post-setup stage chain migrate safely to the issue-driven model.

## Target State

- `.ai-dev-template.workflow-state.json` uses only `setup` and `issue_driven`
- GitHub Issues carry explicit task metadata
- GitHub Project carries canonical execution status
- agents route work from task ownership and dependencies instead of repository-wide stages

## Migration Steps

1. Keep the repository in `setup` while updating workflow docs, issue templates, labels, and GitHub Project fields.
2. Create or update the top-level initiative Epic for each active workstream.
3. Convert existing intake work into `business_analysis` tasks when business clarification is still incomplete.
4. Convert existing analysis work into `system_analysis` tasks and make sure decomposition exists in `docs/delivery/contour-task-matrix.md`.
5. Create separate `design` tasks for any UX or visual work that was previously hidden inside analysis or frontend implementation.
6. Split existing development work into one `implementation` issue per owner contour and per atomic deliverable.
7. Represent rollout and validation as separate `deploy` and `e2e` tasks linked to the same initiative.
8. Backfill issue dependencies and move tasks into the required GitHub Project statuses.
9. Switch `.ai-dev-template.workflow-state.json` from `setup` to `issue_driven` only after the GitHub operating model is validated.

## Mapping From Old Stages

| Old stage | New task type |
| --- | --- |
| `intake` | `business_analysis` |
| `analysis` | `system_analysis` |
| `development` | `implementation` |
| `deploy` | `deploy` |
| `e2e_test` | `e2e` |

Design work that was previously implicit inside `analysis` or `frontend` should become explicit `design` tasks when downstream work depends on it.

## Safety Rules

- Do not switch to `issue_driven` until required issue templates, labels, and project fields exist.
- Do not carry forward broad multi-contour implementation issues unchanged. Split them first.
- Do not mark tasks `Ready` while their dependencies are still open.
- Do not treat the migration complete until every active initiative has a parent Epic and a visible dependency chain.
