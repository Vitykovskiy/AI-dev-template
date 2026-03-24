# Workflow Configuration

## Purpose

`.ai-dev-template.config.json` stores operational policy for the repository.

It configures how the agent executes work inside the lifecycle. It does not replace the fixed stage model defined in `AGENTS.md` and `docs/07-workflow.md`.

## Fixed Lifecycle vs Configurable Policy

The following are fixed by the template and are not optional:

- 6 lifecycle stages: `setup`, `intake`, `analysis`, `delivery`, `deploy`, `e2e-test`
- explicit primary role per stage
- delivery from canonical analysis artifacts
- separate deploy stage
- separate e2e-test stage
- initiative closure only after successful e2e validation

The following remain configurable:

- language for docs, issues, PR text, comments, and commits
- execution mode
- approval checkpoints
- PR, review, and merge behavior
- persistence policy for temporary work artifacts

## Execution Modes

- `autonomous`: continue through available work within the current allowed stage flow until a real blocker or configured checkpoint is reached.
- `staged`: pause between work stages and wait for explicit human confirmation.

Execution mode affects pacing. It does not authorize skipping `intake`, `analysis`, `deploy`, or `e2e-test`.

## Pull Request Policy

If `pull_requests.enabled` is `true`, PR policy applies to the tasks executed within each stage.

Typical policy fields include:

- whether every task requires a PR
- whether drafts are required first
- whether review is mandatory
- reviewer type
- merge checks and approvals
- whether the agent may self-merge

PR policy changes the delivery mechanics, not the lifecycle gates.

## Artifact Persistence

Repository-persisted artifacts remain the source of truth for reusable knowledge:

- `AGENTS.md`
- `instructions/`
- `docs/`
- templates and workflow assets

Temporary local work artifacts may follow repository policy, but canonical lifecycle documents must remain in the repository.

## GitHub Token Requirements

Minimum expected scopes:

- `repo`
- `project`

Recommended additional scopes:

- `read:org`
- `workflow`

These scopes provide capability baseline only. Repository permissions and branch protections still apply.
