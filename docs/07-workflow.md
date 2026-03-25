# Workflow

## Lifecycle

The repository enforces a fixed 6-stage lifecycle tracked by `.ai-dev-template.workflow-state.json`.

Allowed `current_stage` values:

1. `setup`
2. `intake`
3. `analysis`
4. `development`
5. `deploy`
6. `e2e_test`

The lifecycle is sequential, but the state file allows explicit rollback to an earlier stage when a blocker is found.

## State File Rule

`.ai-dev-template.workflow-state.json` is the only source of truth for the current workflow stage.

Rules:

- read the file at the start of every session;
- use `current_stage` exactly as written;
- change stages only by updating the state file;
- do not delete or restore instruction files to represent workflow progress.

## Git Delivery Rule

Before starting task work, sync Git state and confirm the current working branch is based on the latest remote state of its parent branch.

After creating a commit, sync again and confirm the branch still grows from the latest working branch state before further changes, handoff, or PR creation.

Every completed stage handoff must have repository-persisted evidence and verified operational side effects:

- commit all repository changes required for the completed stage output;
- push the commit before considering the task or stage handoff complete;
- if `pull_requests.enabled = true`, follow the configured PR policy after pushing;
- if `pull_requests.enabled = false`, push directly to the assigned working branch;
- verify the push and any required GitHub side effects before reporting completion;
- do not leave completed stage outputs only in the local worktree;
- do not treat GitHub-only changes as a complete handoff until the corresponding canonical repository documents are updated, committed, and pushed.

If the branch is behind, diverged, or based on an outdated parent, reconcile branch history first and only then continue the workflow task.

## Text Encoding Rule

Workflow text exchanged through repository files or external delivery tools must use explicit UTF-8 encoding.

Rules:

- use UTF-8 for markdown, templates, issue bodies, PR bodies, commit-message files, and other workflow text artifacts;
- on Windows or in PowerShell, do not trust implicit default encoding when a file may contain non-ASCII text;
- when writing temporary files for `gh`, `git`, or related tools, encode them explicitly as UTF-8, preferably without BOM;
- if a GitHub-side artifact or repository text shows mojibake or replacement characters, rewrite the source file in explicit UTF-8 and repeat the operation instead of continuing with corrupted text.

## Stage Ownership

| Stage | Primary executor | Main output |
| --- | --- | --- |
| `setup` | technical agent | initialized repository and workflow baseline |
| `intake` | business analyst | business context, scenarios, scope, acceptance expectations |
| `analysis` | system analyst | implementation-ready specification package |
| `development` | contour role (`frontend`, `backend`, `devops`, etc.) | contour implementation from approved specs |
| `deploy` | devops | deployed system in target environment |
| `e2e_test` | qa-e2e | end-to-end validation result |

## Mandatory Flow

1. Start every session with `AGENTS.md`.
2. Read `.ai-dev-template.workflow-state.json`.
3. Determine the active role for the session.
4. Read only the instruction branch and canonical artifacts allowed for that stage and role.
5. Produce only the artifacts and decisions owned by that stage and role.

## Stage Gates

### 1. Setup

Goal:
prepare the repository, workflow, and baseline documentation.

Exit condition:
the repository is ready for intake and later role routing.

Mandatory completion conditions:

- `.ai-dev-template.config.json` has been read and applied to the repository workflow assets and instructions;
- the repository is connected to GitHub Issues;
- the repository is connected to a GitHub Project when `project_tracking = github_project`;
- the GitHub Project exists, is reachable, and its URL plus validation status are recorded in `docs/09-integrations.md`;
- required GitHub workflow infrastructure for the configured process is prepared during setup, including project structure, labels, and other repository-management assets needed by later stages;
- setup-side changes to instructions, docs, labels, project structure, or repository workflow assets are verified and recorded before stage exit;
- if the configured GitHub Project does not exist yet, create it or stop with a setup blocker instead of advancing the stage.

State transition:
update `current_stage` from `setup` to `intake` when setup is complete.

### 2. Intake

Goal:
capture the business problem, target outcome, users, scenarios, scope, constraints, and success expectations.

Rules:

- work one semantic block at a time;
- do not decompose into implementation tasks yet;
- do not design system internals yet.

Exit condition:
the initiative is understood well enough to start system analysis.

Mandatory completion conditions:

- the active initiative record exists in GitHub Issues;
- the initiative identifier is reflected in the repository context files needed by later stages;
- the intake docs and the GitHub initiative record describe the same first-version boundary and success expectations.

State transition:
update `current_stage` from `intake` to `analysis` when intake is complete.

### 3. Analysis

Goal:
create the canonical implementation-ready package in `docs/analysis/`.

The minimum required package includes:

- problem context
- user scenarios
- version scope and acceptance
- system modules
- module relationships
- domain model and data formats
- API, event, and integration contracts
- UI specification
- cross-cutting concerns
- contour task decomposition

Exit condition:
development roles can execute from their own artifacts and contracts without inferring behavior from sibling contour code.

Mandatory completion conditions:

- `docs/delivery/contour-task-matrix.md` is complete enough to support contour-by-contour execution;
- each atomic contour implementation task from the decomposition is represented as its own GitHub Issue;
- contour-specific implementation tasks are created in GitHub Issues after analysis is complete;
- those tasks are represented in GitHub Project before `current_stage` moves to `development`.

State transition:
update `current_stage` from `analysis` to `development` when the analysis package is implementation-ready.

### 4. Development

Goal:
implement one contour at a time from approved analysis artifacts.

Rules:

- one task, one contour;
- one session, one development role;
- frontend uses frontend specs and contracts;
- backend uses backend specs and contracts;
- missing specification is a blocker, not a coding prompt.

Exit condition:
all contour tasks for the initiative are implemented and documented.

State transition:
update `current_stage` from `development` to `deploy` when contour delivery is complete.

### 5. Deploy

Goal:
roll the delivered system into the target environment as a separate stage.

Exit condition:
deployment completes and the target environment is ready for integrated validation.

State transition:
update `current_stage` from `deploy` to `e2e_test` when rollout succeeds.

### 6. E2E Test

Goal:
validate the deployed system against canonical user scenarios and acceptance criteria.

Exit condition:
e2e validation passes. Only then may the initiative be considered complete.

State transition:
keep `e2e_test` until validation finishes. If a blocker is found, move the state file back to the appropriate prior stage.

## Return-To-Analysis Rule

Return the initiative to `analysis` when any later-stage role finds a material gap in:

- expected user behavior;
- UI states or interactions;
- domain rules;
- payload or data formats;
- API or event contracts;
- non-functional or cross-cutting requirements;
- acceptance criteria needed for implementation, rollout, or testing.

Do not close the gap with ad hoc code assumptions.

Use explicit state rollback in `.ai-dev-template.workflow-state.json`.

## GitHub Lifecycle

GitHub Issues and GitHub Project remain the operational system of record.

Role split:

- GitHub Issues are the canonical initiative and task records;
- GitHub Project is the canonical delivery-status board for those issues;
- repository docs remain the canonical source for product, analysis, architecture, and workflow context.

Required initiative flow:

1. create or update the initiative record during `intake`;
2. complete the analysis package during `analysis`;
3. create contour-specific implementation tasks in GitHub Issues after analysis;
4. place those tasks in GitHub Project before starting `development`;
5. execute deploy tasks after contour development;
6. execute e2e tasks after deployment;
7. close the initiative only after successful e2e validation.

## Decomposition Rules

- Tasks must be atomic and contour-specific.
- Each atomic contour implementation task must map to exactly one GitHub Issue.
- Each development task must have exactly one owning contour.
- Cross-contour work is split into linked tasks instead of one shared task.
- Deploy and e2e tasks are separate from implementation tasks.

## Documentation Update Rules

- Business problem or goals change: update `docs/01-product-vision.md` and `docs/02-business-requirements.md`.
- Scope or acceptance changes: update `docs/03-scope-and-boundaries.md` and `docs/analysis/version-scope-and-acceptance.md`.
- System design changes: update the relevant files in `docs/analysis/`.
- Repository structure or runtime placement changes: update `docs/05-architecture.md`.
- Lifecycle, state, or role rules change: update `AGENTS.md`, `.ai-dev-template.workflow-state.json`, `instructions/`, and this file together.
- Material decisions change: update `docs/06-decision-log.md`.

## Execution Mode And PR Policy

The repository still uses `.ai-dev-template.config.json` for execution mode, approvals, and PR/review policy.

Those settings control how a stage is executed. They do not change the required lifecycle order or the state-file routing model defined in this document.
