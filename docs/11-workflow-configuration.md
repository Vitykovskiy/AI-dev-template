# Workflow Configuration

## Purpose

`.ai-dev-template.config.json` stores operational policy for the repository.

It configures how the agent executes work inside the lifecycle. It does not replace the explicit workflow stage stored in `.ai-dev-template.workflow-state.json`.

## Fixed Lifecycle vs Configurable Policy

The following are fixed by the template and are not optional:

- 6 lifecycle stages in `.ai-dev-template.workflow-state.json`: `setup`, `intake`, `analysis`, `development`, `deploy`, `e2e_test`
- explicit primary role per stage
- development from canonical analysis artifacts
- separate deploy stage
- separate e2e_test stage
- initiative closure only after successful e2e validation

The following remain configurable:

- frontend architecture policy, including whether FSD is the expected frontend structure
- language for docs, issues, PR text, comments, and commits
- execution mode
- approval checkpoints
- PR, review, and merge behavior
- persistence policy for temporary work artifacts

Encoding rule is not configurable: workflow text artifacts must be stored and exchanged in UTF-8 so Git and GitHub tooling interpret them consistently.

## Frontend Architecture Policy

Use `architecture.use_fsd` to decide whether the repository treats Feature-Sliced Design as the expected frontend structure.

- `true`: frontend guidance should explicitly use FSD layers, boundaries, and terminology.
- `false`: the template must not require FSD and should allow another team-approved frontend structure.

Example:

```json
{
  "architecture": {
    "use_fsd": true
  }
}
```

## Execution Modes

- `autonomous`: continue through available work within the current allowed stage flow until a real blocker or configured checkpoint is reached.
- `staged`: pause between work stages and wait for explicit human confirmation.

Execution mode affects pacing. It does not authorize skipping `intake`, `analysis`, `deploy`, or `e2e_test`.

## Pull Request Policy

If `pull_requests.enabled` is `true`, PR policy applies to the tasks executed within each stage.

Typical policy fields include:

- whether every task requires a PR
- whether drafts are required first
- whether review is mandatory
- reviewer type
- merge checks and approvals
- whether the agent may self-merge

PR policy changes the delivery mechanics, not the lifecycle gates or the state-file model.

If `pull_requests.enabled` is `false`, the agent must still persist repository-changing work by commit and push:

- commit completed stage outputs to the assigned working branch;
- push directly to that working branch;
- treat local-only completed changes as unfinished work, not as a completed handoff.

## Artifact Persistence

Repository-persisted artifacts remain the source of truth for reusable knowledge:

- `AGENTS.md`
- `.ai-dev-template.workflow-state.json`
- `instructions/`
- `docs/`
- templates and workflow assets

Temporary local work artifacts may follow repository policy, but canonical lifecycle documents must remain in the repository.

Operational side effects in GitHub or other delivery systems do not replace repository persistence requirements. If a stage updates the operational system of record, the corresponding canonical repository evidence must also be updated, committed, and pushed.

On Windows or in PowerShell, temporary files passed to `gh`, `git`, or similar tools must be written with explicit UTF-8 encoding instead of shell-default encoding.

## GitHub Token Requirements

Minimum expected scopes:

- `repo`
- `project`

Recommended additional scopes:

- `read:org`
- `workflow`

These scopes provide capability baseline only. Repository permissions and branch protections still apply.
