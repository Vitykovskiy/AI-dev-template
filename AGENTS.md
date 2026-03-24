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

Critical rule: do not infer the current stage from deleted files, missing files, or folder structure in `instructions/`. Instruction files are permanent template assets.

## Stage Detection

Read `.ai-dev-template.workflow-state.json` and use `current_stage` exactly as written.

If the file is missing, malformed, or contains an unsupported value, stop and report a blocker.

## Stage Transitions

Stage transitions are performed by updating `.ai-dev-template.workflow-state.json`.

Use state changes for both forward progress and rollback:

- `deploy` -> `development`
- `e2e_test` -> `analysis`
- `e2e_test` -> `development`

Do not delete or recreate instruction files as a workflow mechanism.

One-time exception:

- repository bootstrap may begin in `setup`, but leaving `setup` still happens by updating the state file, not by deleting setup instructions

## Role Detection

After selecting the stage, determine the role for the current session:

- `setup`: technical agent
- `intake`: business analyst
- `analysis`: system analyst
- `development`: exactly one contour role per session, such as `frontend`, `backend`, `devops`, or another explicit contour owner
- `deploy`: devops
- `e2e_test`: qa-e2e

For `development`, do not mix contours in one execution branch. If the work spans multiple contours, use separate tasks and separate role sessions.

## Allowed Reading By Stage

Read only the files listed for the active stage. Do not preload files from other stages.

### setup

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/setup/router.md`
3. `instructions/setup/technical-agent.md`

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

### analysis

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/analysis/router.md`
3. `instructions/analysis/system-analyst.md`

Read only the canonical analysis package and adjacent overview docs:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/README.md`
- the specific files in `docs/analysis/` that are required for the current initiative

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
