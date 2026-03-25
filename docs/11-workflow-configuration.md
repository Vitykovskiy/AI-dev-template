# Workflow Configuration

## Purpose

`.ai-dev-template.config.json` stores operational policy for the repository.

It configures how the agent executes work inside the template operating model. It does not replace GitHub task ownership, dependencies, or GitHub Project state.

## Fixed Operating Model vs Configurable Policy

The following are fixed by the template and are not optional:

- `setup` is the only repository-wide bootstrap stage;
- post-setup work is issue-driven, not stage-driven;
- post-setup work starts from a single `business_analysis` issue and then flows through `system_analysis` into block-level delivery tasks;
- explicit task types and owner contours are required after setup;
- `system_analysis` is the canonical source of truth for implementation inputs and delivery decomposition;
- each integrated deliverable is represented by a parent `block_delivery` task;
- one operational task has one owner contour;
- deploy remains separate from implementation tasks;
- e2e remains separate from deploy and implementation tasks;
- project status vocabulary includes explicit waiting-for-testing and waiting-for-fix states;
- initiative closure is allowed only after required block-level validation, deploy work, and e2e tasks finish successfully.

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

- `autonomous`: continue through available tasks whose dependencies are resolved until a real blocker or configured checkpoint is reached.
- `staged`: pause between major task handoffs and wait for explicit human confirmation.

Execution mode affects pacing. It does not authorize skipping business analysis, system analysis, block decomposition, design, deploy, or e2e tasks when they are required by the initiative.

## Pull Request Policy

If `pull_requests.enabled` is `true`, PR policy applies to the tasks executed in the current owner contour.

Typical policy fields include:

- whether every task requires a PR
- whether drafts are required first
- whether review is mandatory
- reviewer type
- merge checks and approvals
- whether the agent may self-merge

PR policy changes the delivery mechanics, not the task readiness, dependency, or ownership rules.

If `pull_requests.enabled` is `false`, the agent must still persist repository-changing work by commit and push:

- commit completed task outputs to the assigned working branch;
- push directly to that working branch;
- treat local-only completed changes as unfinished work, not as a completed handoff.

## Artifact Persistence

Repository-persisted artifacts remain the source of truth for reusable knowledge:

- `AGENTS.md`
- `.ai-dev-template.workflow-state.json`
- `instructions/`
- `docs/`
- templates and workflow assets

Temporary local work artifacts may follow repository policy, but canonical workflow and task-governance documents must remain in the repository.

Operational side effects in GitHub or other delivery systems do not replace repository persistence requirements. If a task updates the operational system of record, the corresponding canonical repository evidence must also be updated, committed, and pushed.

On Windows or in PowerShell, temporary files passed to `gh`, `git`, or similar tools must be written with explicit UTF-8 encoding instead of shell-default encoding.

## GitHub Token Requirements

Minimum expected scopes:

- `repo`
- `project`

Recommended additional scopes:

- `read:org`
- `workflow`

These scopes provide capability baseline only. Repository permissions, project permissions, and branch protections still apply.
