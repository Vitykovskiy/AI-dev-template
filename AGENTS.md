# AGENTS.md

Read this file first at the start of every new session.

## Router Goal

This repository uses a strict 6-stage workflow with explicit role separation:

1. setup
2. intake
3. analysis
4. delivery
5. deploy
6. e2e-test

The agent must determine the current stage and the active role before reading any detailed instructions.

Critical rule: do not read the full `instructions/` tree. Read only the files selected by this router for the current stage and role.

## Stage Detection

Determine the current stage by checking the repository state in this order:

1. If repository bootstrap is incomplete, use `setup`.
   Bootstrap is incomplete when the repository still needs environment validation, workflow initialization, or canonical project structure setup.
2. Else if task intake artifacts are missing or the current initiative is not yet captured, use `intake`.
   Intake is the stage where the business analyst works with the requester and records the business problem and user scenarios.
3. Else if the implementation-ready analysis package is incomplete, use `analysis`.
   Analysis is incomplete if required system modules, contracts, UI behavior, data formats, cross-cutting concerns, or contour decomposition are not fixed in `docs/analysis/`.
4. Else if implementation tasks for a specific contour are active, use `delivery`.
5. Else if contour delivery is complete and the initiative is waiting for environment rollout, use `deploy`.
6. Else if deployment is complete and the initiative is waiting for end-to-end validation, use `e2e-test`.

If a delivery, deploy, or test executor discovers a material gap in requirements, contracts, UI behavior, integration behavior, or acceptance criteria, stop execution and return the initiative to `analysis`.

## Role Detection

After selecting the stage, determine the role for the current session:

- `setup`: technical agent
- `intake`: business analyst
- `analysis`: system analyst
- `delivery`: exactly one contour role per session, such as `frontend`, `backend`, `devops`, or another explicit contour owner
- `deploy`: devops
- `e2e-test`: qa-e2e

For `delivery`, do not mix contours in one execution branch. If the work spans multiple contours, use separate tasks and separate role sessions.

## Allowed Reading By Stage

Read only the files listed for the active stage. Do not preload files from other stages.

### setup

Read, in order:

1. `instructions/setup/router.md`
2. `instructions/setup/technical-agent.md`

### intake

Read, in order:

1. `instructions/intake/router.md`
2. `instructions/intake/business-analyst.md`

Read only the intake-facing canonical docs needed to capture the task:

- `docs/00-project-overview.md`
- `docs/01-product-vision.md`
- `docs/02-business-requirements.md`
- `docs/03-scope-and-boundaries.md`

### analysis

Read, in order:

1. `instructions/analysis/router.md`
2. `instructions/analysis/system-analyst.md`

Read only the canonical analysis package and adjacent overview docs:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/README.md`
- the specific files in `docs/analysis/` that are required for the current initiative

### delivery

Read, in order:

1. `instructions/delivery/router.md`
2. exactly one role file from `instructions/delivery/roles/`

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

1. `instructions/deploy/router.md`
2. `instructions/deploy/devops.md`

Read only deployment-relevant artifacts:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/delivery/contour-task-matrix.md`
- deployment-specific environment and rollout docs

### e2e-test

Read, in order:

1. `instructions/e2e-test/router.md`
2. `instructions/e2e-test/qa-e2e.md`

Read only the user-scenario, acceptance, environment, and rollout artifacts required to validate the delivered system.

## Blocking Rules

Stop and report a blocker when any of the following is true:

- the current stage is ambiguous;
- the active role is ambiguous;
- canonical analysis artifacts are insufficient for implementation, deployment, or testing;
- a task tries to combine multiple contours without explicit decomposition;
- a role would need to read unrelated instructions or unrelated code just to infer expected behavior.

When blocked by missing analysis, explicitly state that the initiative must return to stage `analysis`.
