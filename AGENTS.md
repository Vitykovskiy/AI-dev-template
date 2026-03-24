# AGENTS.md

Read this file first at the start of every new session.

## Router Goal

This repository uses a strict 6-stage workflow with explicit role separation.

The current stage is stored in `.ai-dev-template.workflow-state.json`.

`current_stage` is the only source of truth for workflow stage detection.

Allowed values:

1. `setup`
2. `intake`
3. `analysis`
4. `development`
5. `deploy`
6. `e2e_test`

## Stage Detection

Read `.ai-dev-template.workflow-state.json` and use `current_stage` exactly as written.

If the file is missing, malformed, or contains an unsupported value, stop and report a blocker.

## Git Delivery Rule

Before starting a task, sync Git state and confirm the working branch is based on the latest remote state of its parent branch.

After creating a commit, sync again and confirm the branch still grows from the latest working branch state before continuing, handing off, or opening a PR.

Every completed stage handoff must have repository-persisted evidence and verified operational side effects:

- commit all repository changes required for the completed stage output;
- push that commit before considering the task or stage handoff complete;
- if `pull_requests.enabled = true`, follow the configured PR policy after pushing;
- if `pull_requests.enabled = false`, push directly to the assigned working branch;
- verify the push and any required GitHub side effects before reporting completion;
- do not leave completed `setup`, `intake`, `analysis`, `development`, `deploy`, or `e2e_test` changes only in the local worktree;
- do not treat GitHub-only changes as a complete handoff until the corresponding canonical repository documents are updated, committed, and pushed.

If the branch is behind, diverged, or based on an outdated parent, stop implementation work, reconcile the branch history, and then continue.

## Stage Transitions

Stage transitions are performed by updating `.ai-dev-template.workflow-state.json`.

Use state changes for both forward progress and rollback:

- `deploy` -> `development`
- `e2e_test` -> `analysis`
- `e2e_test` -> `development`

One-time exception:

- repository bootstrap may begin in `setup`

## Role Detection

After selecting the stage, determine the role for the current session:

- `setup`: senior technical agent
- `intake`: senior business analyst
- `analysis`: senior system analyst
- `development`: exactly one senior contour owner per session, such as `frontend`, `backend`, `devops`, or `qa-e2e`
- `deploy`: senior devops
- `e2e_test`: senior qa-e2e

For `development`, a contour is a single delivery role domain such as `frontend`, `backend`, `devops`, or `qa-e2e`. Do not mix multiple contours in one execution branch. If the work spans multiple contours, split it into separate tasks and separate role sessions.

## Allowed Reading By Stage

Read only the files listed for the active stage. Do not preload files from other stages.

### setup

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/setup/router.md`
3. `instructions/setup/technical-agent.md`

Setup must ensure the repository is configured according to `.ai-dev-template.config.json` before leaving the stage. Apply the configuration to workflow assets, instructions, and required repository-management infrastructure. If GitHub Project tracking is configured and no project exists, create or connect one, record it in the canonical docs, and do not advance the stage until that integration is validated.

### intake

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/intake/router.md`
3. `instructions/intake/business-analyst.md`

Read only the intake-facing canonical docs needed to capture the task:

- `docs/00-project-overview.md`
- `docs/01-product-vision.md`
- `docs/02-business-requirements.md`
- `docs/03-scope-and-boundaries.md`

Before leaving `intake`, ensure the initiative exists in GitHub Issues and that the repository intake artifacts match that initiative record.

### analysis

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/analysis/router.md`
3. `instructions/analysis/system-analyst.md`

Read only the canonical analysis package and adjacent overview docs:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/09-integrations.md`
- `docs/analysis/README.md`
- the specific files in `docs/analysis/` that are required for the current initiative

Do not treat `docs/delivery/contour-task-matrix.md` as sufficient operational decomposition by itself. Before leaving `analysis`, publish each atomic contour-specific implementation task as its own GitHub Issue and place those issues in GitHub Project.

### development

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/delivery/router.md`
3. exactly one role file from `instructions/delivery/roles/`

Allowed role files:

- `instructions/delivery/roles/frontend.md`
- `instructions/delivery/roles/backend.md`
- `instructions/delivery/roles/devops.md`
- `instructions/delivery/roles/qa-e2e.md`

Read only the canonical artifacts for the assigned contour and the exact contracts it depends on.

Minimum common context:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/README.md`
- `docs/delivery/contour-task-matrix.md`

Contour-specific reading:

- `frontend`: UI behavior, screen specs, frontend task decomposition, and consumed contracts
- `backend`: modules, domain model, backend task decomposition, and produced contracts
- `devops`: deployment topology, runtime requirements, operational constraints
- `qa-e2e`: user scenarios, acceptance criteria, deployed environment details

Do not read sibling contour implementation code as a substitute for missing analysis. Missing specification is a blocker that returns the work to `analysis`.
Do not implement work that belongs to another contour under the pretext of integration, convenience, or cleanup. If the task requires another contour's owned output, stop and return to the GitHub task decomposition layer instead of silently absorbing the work.

### deploy

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/deploy/router.md`
3. `instructions/deploy/devops.md`

Read only deployment-relevant artifacts:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/delivery/contour-task-matrix.md`
- deployment-specific environment and rollout docs

### e2e_test

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/e2e-test/router.md`
3. `instructions/e2e-test/qa-e2e.md`

Read only the user-scenario, acceptance, environment, and rollout artifacts required to validate the delivered system.

## Blocking Rules

Stop and report a blocker when any of the following is true:

- `.ai-dev-template.workflow-state.json` is missing or invalid;
- the current stage is ambiguous;
- the active role is ambiguous;
- canonical analysis artifacts are insufficient for implementation, deployment, or testing;
- a task tries to combine multiple contours without explicit decomposition;
- a role would need to read unrelated instructions or unrelated code just to infer expected behavior.

When blocked by missing analysis, explicitly state that the initiative must return to stage `analysis` by updating `.ai-dev-template.workflow-state.json`.
