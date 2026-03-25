# AGENTS.md

Read this file first at the start of every new session.

## Router Goal

This repository uses a two-mode workflow:

1. `setup` bootstraps the repository, workflow assets, labels, and GitHub operating model.
2. `issue_driven` runs all post-setup work through GitHub Issues, task dependencies, owner contours, and GitHub Project state.

After `setup`, operational work starts from exactly one `business_analysis` issue and then flows through issue hierarchy instead of repository-wide stages.

## Bootstrap State Detection

Read `.ai-dev-template.workflow-state.json` and use `current_stage` exactly as written.

Allowed values:

1. `setup`
2. `issue_driven`

If the file is missing, malformed, or contains an unsupported value, stop and report a blocker.

`current_stage` is a bootstrap guardrail only:

- `setup` means the repository is still being prepared and no operational task routing may happen yet;
- `issue_driven` means setup is complete and all routing must come from the active GitHub Issue plus GitHub Project state.

Do not reintroduce `intake`, `analysis`, `development`, `deploy`, or `e2e_test` as global repository stages.

## Git Delivery Rule

Before starting a task, sync Git state and confirm the working branch is based on the latest remote state of its parent branch.

After creating a commit, sync again and confirm the branch still grows from the latest working branch state before continuing, handing off, or opening a PR.

Every completed task handoff must have repository-persisted evidence and verified operational side effects:

- commit all repository changes required for the completed task output;
- push that commit before considering the task handoff complete;
- if `pull_requests.enabled = true`, follow the configured PR policy after pushing;
- if `pull_requests.enabled = false`, push directly to the assigned working branch;
- verify the push and any required GitHub side effects before reporting completion;
- do not leave completed task outputs only in the local worktree;
- do not treat GitHub-only changes as a complete handoff until the corresponding canonical repository documents are updated, committed, and pushed.

If the branch is behind, diverged, or based on an outdated parent, stop implementation work, reconcile the branch history, and then continue.

## Text Encoding Rule

When creating or updating text files that will be consumed by Git, GitHub CLI, or other external tools, use explicit UTF-8 encoding.

- treat UTF-8 as the required default for markdown, issue bodies, PR bodies, commit-message files, templates, and other workflow text artifacts;
- on Windows or in PowerShell, do not rely on implicit default encoding for files that may contain non-ASCII text;
- when creating temporary files for `gh` or related tooling, write them in UTF-8 explicitly, preferably UTF-8 without BOM;
- if text appears corrupted after a tool call, treat it as an encoding failure and rewrite the source file with explicit UTF-8 before retrying.

## Post-Setup Routing

When `current_stage = "issue_driven"`, start from the active GitHub Issue instead of a repository-wide stage.

Every operational task must have these required attributes, expressed through issue body fields, labels, or project fields:

- task type: one of `initiative`, `business_analysis`, `system_analysis`, `block_delivery`, `design`, `implementation`, `deploy`, `e2e`;
- owner contour: exactly one of `business-analyst`, `system-analyst`, `designer`, `frontend`, `backend`, `devops`, `qa-e2e`;
- parent initiative: the top-level Epic or initiative issue;
- parent block task: required for implementation issues that contribute to an integrated delivery block;
- dependencies: explicit issue links or a `Blocked by` list;
- ready rule: why the task is allowed to start;
- done rule: what must be true to close the task;
- canonical inputs: the specific repository artifacts and linked issues the task may rely on;
- project status: one of `Inbox`, `Ready`, `In Progress`, `Blocked`, `Waiting for Testing`, `Testing`, `Waiting for Fix`, `In Review`, `Done`.

Required task chain after setup:

1. one `business_analysis` issue confirms the business problem and operating vocabulary;
2. one `system_analysis` issue produces the canonical specification package;
3. `system_analysis` decomposes delivery into one or more parent `block_delivery` tasks;
4. each `block_delivery` task owns child implementation issues, one per responsible contour (`frontend`, `backend`, `devops` when needed, plus `designer` only when the work is explicitly implementation rather than upstream design);
5. `qa-e2e` validates the integrated result at the `block_delivery` level after all required child implementation issues are done;
6. `deploy` remains separate when rollout is required for the validated slice.

## Task Selection Rules

An agent may work only on a task when all of the following are true:

- the task owner contour matches the agent's role for the session;
- all declared dependencies are already complete or explicitly marked as no longer blocking;
- the GitHub Project status is `Ready` or `In Progress`;
- the canonical inputs named by the task exist and are sufficient;
- the task belongs to exactly one owner contour.

An agent must not:

- execute a blocked task;
- execute work owned by another contour;
- combine multiple owner contours into one task;
- claim a higher-layer task is complete while its dependent lower-layer tasks remain unfinished;
- replace dependency checks with guesses from sibling code.

## Role Detection

Use the active task's `owner contour` field to determine the role for the current session:

- `business-analyst`
- `system-analyst`
- `designer`
- `frontend`
- `backend`
- `devops`
- `qa-e2e`

If the owner contour is missing or ambiguous, stop and report a blocker.

## Allowed Reading By Mode And Task Type

Read only the files listed for the active mode and task type.

### setup

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/setup/router.md`
3. `instructions/setup/technical-agent.md`

Setup must ensure the repository is configured according to `.ai-dev-template.config.json` before switching to `issue_driven`. Apply the configuration to workflow assets, instructions, issue templates, labels, project structure, and required repository-management infrastructure. If GitHub Project tracking is configured and no project exists, create or connect one, record it in the canonical docs, and do not advance the bootstrap state until that integration is validated.

### business_analysis

Read, in order:

1. `instructions/intake/router.md`
2. `instructions/intake/business-analyst.md`
3. `docs/00-project-overview.md`
4. `docs/01-product-vision.md`
5. `docs/02-business-requirements.md`
6. `docs/03-scope-and-boundaries.md`

### system_analysis

Read, in order:

1. `instructions/analysis/router.md`
2. `instructions/analysis/system-analyst.md`
3. `docs/00-project-overview.md`
4. `docs/07-workflow.md`
5. `docs/09-integrations.md`
6. `docs/analysis/README.md`
7. the specific files in `docs/analysis/` required for the initiative

### design

Read, in order:

1. `instructions/design/router.md`
2. `instructions/design/designer.md`
3. `docs/00-project-overview.md`
4. `docs/analysis/user-scenarios.md`
5. `docs/analysis/version-scope-and-acceptance.md`
6. `docs/analysis/ui-specification.md`
7. the specific design-system or UX artifacts required for the task

### implementation

Read, in order:

1. `instructions/delivery/router.md`
2. exactly one role file from `instructions/delivery/roles/`

Allowed role files:

- `instructions/delivery/roles/designer.md`
- `instructions/delivery/roles/frontend.md`
- `instructions/delivery/roles/backend.md`
- `instructions/delivery/roles/devops.md`
- `instructions/delivery/roles/qa-e2e.md`

Minimum common context:

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/README.md`
- `docs/delivery/contour-task-matrix.md`

Read only the canonical artifacts for the assigned contour and the exact contracts it depends on.

### deploy

Read, in order:

1. `instructions/deploy/router.md`
2. `instructions/deploy/devops.md`
3. `docs/00-project-overview.md`
4. `docs/07-workflow.md`
5. `docs/analysis/cross-cutting-concerns.md`
6. `docs/delivery/contour-task-matrix.md`
7. deployment-specific environment and rollout docs

### e2e

Read, in order:

1. `instructions/e2e-test/router.md`
2. `instructions/e2e-test/qa-e2e.md`
3. `docs/00-project-overview.md`
4. `docs/analysis/user-scenarios.md`
5. `docs/analysis/version-scope-and-acceptance.md`
6. deployment result and environment docs

## Blocking Rules

Stop and report a blocker when any of the following is true:

- `.ai-dev-template.workflow-state.json` is missing or invalid;
- setup is not complete but work tries to bypass `setup`;
- the active issue is missing task metadata or owner contour;
- the task has unresolved dependencies;
- the active role is ambiguous;
- canonical analysis or design artifacts are insufficient for implementation, deployment, or testing;
- a task tries to combine multiple contours without explicit decomposition;
- a role would need to read unrelated instructions or sibling implementation code just to infer expected behavior.

When blocked by missing business context, route the work to a `business_analysis` task.
When blocked by missing specifications, contracts, decomposition details, or UX behavior, stop implementation, mark the implementation task `Blocked`, and create or request a linked `system_analysis` follow-up issue before any coding continues.
