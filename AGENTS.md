# AGENTS.md

Read this file first at the start of every new session.

## Router Goal

This repository uses a two-mode workflow:

1. `setup` bootstraps the repository, workflow assets, labels, and GitHub operating model.
2. `issue_driven` runs all post-setup work through GitHub Issues, task dependencies, owner contours, and GitHub Project state.

After `setup`, operational work starts from exactly one `business_analysis` issue and then flows through issue hierarchy, task metadata, dependencies, owner contours, and GitHub Project state.

Setup must not transition to `issue_driven` until the repository has a seeded starting backlog containing at least one open `initiative` issue and exactly one open initial `business_analysis` issue.

## Bootstrap State Detection

Read `.ai-dev-template.workflow-state.json` and use `current_stage` exactly as written.

Allowed values:

1. `setup`
2. `issue_driven`

If the file is missing, malformed, or contains an unsupported value, stop and report a blocker.

`current_stage` acts as a bootstrap guardrail with two repository-wide modes:

- `setup` means the repository is being prepared for operational work;
- `issue_driven` means setup is complete and routing comes from the active GitHub Issue plus GitHub Project state.

`current_stage` accepts exactly these two values.

## Git Delivery Rule

Before starting a task, sync Git state and confirm the working branch is based on the latest remote state of its parent branch.

After creating a commit, sync again and confirm the branch still grows from the latest working branch state before continuing, handing off, or opening a PR.

Every completed task handoff must have repository-persisted evidence and verified operational side effects:

- commit all repository changes required for the completed task output;
- push that commit before considering the task handoff complete;
- if `pull_requests.enabled = true`, follow the configured PR policy after pushing;
- if `pull_requests.enabled = false`, push directly to the assigned working branch;
- verify the push and any required GitHub side effects before reporting completion;
- keep completed task outputs in the repository worktree as committed, pushed evidence;
- pair GitHub-side changes with corresponding canonical repository document updates, commits, and pushes.

If the branch is behind, diverged, or based on an outdated parent, stop implementation work, reconcile the branch history, and then continue.

## Text Encoding Rule

When creating or updating text files that will be consumed by Git, GitHub CLI, or other external tools, use explicit UTF-8 encoding.

- treat UTF-8 as the required default for markdown, issue bodies, PR bodies, commit-message files, templates, and other workflow text artifacts;
- on Windows or in PowerShell, use explicit UTF-8 encoding for files that may contain non-ASCII text;
- when creating temporary files for `gh` or related tooling, write them in UTF-8 explicitly, preferably UTF-8 without BOM;
- if text appears corrupted after a tool call, treat it as an encoding failure and rewrite the source file with explicit UTF-8 before retrying.

## Post-Setup Routing

When `current_stage = "issue_driven"`, start from the active GitHub Issue.

Active issue signal:

- the canonical active-task marker is the GitHub Issue label `session: active`;
- at most one open issue may carry `session: active` at a time;
- if exactly one open issue carries `session: active`, that issue is the active issue for the session;
- if multiple open issues carry `session: active`, stop and report a blocker;
- if no open issue carries `session: active`, select one eligible issue automatically, add `session: active`, and then proceed.

Eligible issue selection order:

1. open issues with all required task metadata present and all declared dependencies already complete;
2. prefer issues whose GitHub Project status is `In Progress`;
3. if no eligible `In Progress` issue exists, consider eligible issues with status `Ready`;
4. within the chosen status bucket, sort by priority label in this order: `priority: high`, `priority: medium`, `priority: low`, then unlabeled;
5. if more than one issue still matches, choose the lowest issue number.

Lifecycle rule:

- move `session: active` to the newly selected issue before execution starts;
- remove `session: active` when the task is handed off, blocked, or finished and another issue becomes active;
- do not use GitHub Project status alone as the active-session signal.

Every operational task must have these required attributes, expressed through issue body fields, labels, or project fields:

- task type: one of `initiative`, `business_analysis`, `system_analysis`, `block_delivery`, `implementation`, `deploy`, `e2e`;
- owner contour: exactly one of `business-analyst`, `system-analyst`, `frontend`, `backend`, `devops`, `qa-e2e`;
- parent initiative: the top-level Epic or initiative issue;
- parent block task: required for implementation issues that contribute to an integrated delivery block;
- dependencies: explicit issue links or a `Blocked by` list;
- ready rule: why the task is allowed to start;
- done rule: what must be true to close the task;
- canonical inputs: the specific repository artifacts and linked issues the task may rely on;
- project status: one of `Inbox`, `Ready`, `In Progress`, `Blocked`, `Waiting for Testing`, `Testing`, `Waiting for Fix`, `In Review`, `Done`.

Required task chain after setup:

1. one `business_analysis` issue confirms the business problem and operating vocabulary;
2. one or more bounded `system_analysis` issues produce the canonical specification package in slices for the same initiative or version stream;
3. each `system_analysis` issue decomposes only its approved analysis slice into one or more parent `block_delivery` tasks;
4. each `block_delivery` task owns child implementation issues, one per responsible contour (`frontend`, `backend`, `devops`, `qa-e2e` when contour-owned test assets are required);
5. `qa-e2e` validates the integrated result at the `block_delivery` level after all required child implementation issues are done;
6. `deploy` remains separate when rollout is required for the validated slice.

## Task Selection Rules

An agent works on a task when all of the following are true:

- the task owner contour matches the agent's role for the session;
- all declared dependencies are already complete or explicitly marked as no longer blocking;
- the GitHub Project status is `Ready` or `In Progress`;
- the active issue signal rules identify exactly one current issue;
- the canonical inputs named by the task exist and are sufficient;
- the task belongs to exactly one owner contour.

Execution stays within the assigned contour, resolved dependency set, and declared task boundary.

## Role Detection

Use the active task's `owner contour` field to determine the role for the current session:

- `business-analyst`
- `system-analyst`
- `frontend`
- `backend`
- `devops`
- `qa-e2e`

If the owner contour is missing or ambiguous, stop and report a blocker.

## Role Prompt Rule

After the session role is identified and the corresponding role file is read, adopt that role file's `Execution Profile` section as the active role prompt for the rest of the task.

Rules:

- treat the role profile as mandatory operating behavior;
- apply the role profile together with repository safety, routing, dependency, and blocking rules;
- if a role file says to verify, review, or avoid assumptions, perform that behavior explicitly before reporting completion;
- preserve the role's required rigor throughout the task.

## Allowed Reading By Mode And Task Type

Read only the files listed for the active mode and task type.

### setup

Read, in order:

1. `.ai-dev-template.workflow-state.json`
2. `instructions/setup/router.md`
3. `instructions/setup/technical-agent.md`

Setup must ensure the repository is configured according to `.ai-dev-template.config.json` before switching to `issue_driven`. Apply the configuration to workflow assets, instructions, issue templates, labels, project structure, and required repository-management infrastructure. If GitHub Project tracking is configured, treat only a project already linked to the current repository as an existing project for setup purposes. If no repository-linked project exists, create one, connect it to the repository, record it in the canonical docs, and advance the bootstrap state after that integration is validated.
Setup must also seed the starting backlog before leaving `setup`. At minimum, create one open `initiative` issue plus one open `business_analysis` issue, mark the `business_analysis` issue with `session: active`, and leave that issue ready for immediate execution in `issue_driven`.
If setup consumed a user-updated `.ai-dev-template.config.json`, that file is part of the effective setup state and must be staged, committed, and pushed as part of the setup evidence unless a documented repository policy explicitly says otherwise.

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

### implementation

Read, in order:

1. `instructions/delivery/router.md`
2. exactly one role file from `instructions/delivery/roles/`

Allowed role files:

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
- the active issue signal is missing, duplicated, or cannot be resolved by the documented selection order;
- the task has unresolved dependencies;
- the active role is ambiguous;
- canonical analysis artifacts are insufficient for implementation, deployment, or testing;
- a task tries to combine multiple contours without explicit decomposition;
- a role would need to read unrelated instructions or sibling implementation code just to infer expected behavior.

When blocked by missing business context, route the work to a `business_analysis` task.
When blocked by missing specifications, contracts, decomposition details, or UX behavior, stop implementation, mark the implementation task `Blocked`, and create or request a linked `system_analysis` follow-up issue before any coding continues.
