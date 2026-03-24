# AI Dev Template

Template repository for an AI team that works through a fixed phase-and-role workflow instead of improvising discovery, design, implementation, deployment, and validation in one session.

## Operating Model

The template enforces a 6-stage lifecycle stored in `.ai-dev-template.workflow-state.json`:

1. `setup` - technical agent initializes the repository and workflow.
2. `intake` - business analyst captures the problem, users, scenarios, scope, and acceptance expectations.
3. `analysis` - system analyst produces the implementation-ready specification package.
4. `development` - contour-specific roles implement only their assigned slice, such as `frontend`, `backend`, or contour-specific `devops`.
5. `deploy` - devops rolls the delivered contours into the target environment.
6. `e2e_test` - qa-e2e validates the deployed system against user scenarios and acceptance criteria.

The repository is the canonical source of truth for:

- workflow routing, state, and role rules;
- business context and user scenarios;
- system analysis and integration contracts;
- contour decomposition and lifecycle state;
- architecture, decisions, and operational knowledge.

## Core Principles

- No implementation before analysis is sufficient for development.
- User scenarios are fixed before contour decomposition.
- Screens, interfaces, data formats, and integration contracts are analyzed before coding.
- Frontend works from its own contour specification and contracts, not by reading backend code.
- Backend works from its own contour specification and contracts, not by reading frontend code.
- Missing specification is a blocker that returns the initiative to `analysis`.
- An initiative is not complete until deployment and e2e validation both succeed.

## Repository Layout

- `AGENTS.md` - router that reads `.ai-dev-template.workflow-state.json` and selects the current stage and role branch.
- `.ai-dev-template.workflow-state.json` - explicit workflow state file with `current_stage`.
- `instructions/` - permanent stage-specific and role-specific instructions. These files are not deleted as part of stage transitions.
- `docs/analysis/` - canonical analysis package that gates development.
- `docs/delivery/` - contour decomposition and development handoff artifacts.
- `templates/` - reusable templates for intake, analysis, contour development, deploy, and e2e work.
- `tasks/` - local scratch space only; not a durable backlog.

## How A New Project Starts

1. Create a repository from this template and clone it locally.
2. Add `.ai-dev-template.config.json` to the root.
3. Keep `.ai-dev-template.workflow-state.json` in the root and set `current_stage` to the correct value.
4. Connect the repository to GitHub Issues and a GitHub Project board. If `project_tracking = github_project` and no project exists yet, create one before leaving `setup`.
5. Give the agent access to the repository and the business request.
6. Start with `AGENTS.md`; the router will read the state file and select the matching instruction branch.

## GitHub Workflow

GitHub Issues and GitHub Project remain the operational backbone, but task creation follows the lifecycle:

- intake captures the initiative;
- intake must create or update the initiative record in GitHub Issues before analysis starts;
- analysis produces implementation-ready artifacts;
- analysis also publishes each atomic contour-specific implementation task into its own GitHub Issue and places those issues into GitHub Project before development starts;
- deploy and e2e_test run as separate stages after implementation.

GitHub record split:

- GitHub Issues hold the canonical initiative and task definitions.
- GitHub Project holds the canonical delivery status of those issues.

Completed stage handoffs must have verified evidence. Repository changes must be committed and pushed, and required GitHub-side workflow actions must be verified before completion is reported. When pull requests are disabled, the agent pushes directly to the assigned working branch.

Closing an initiative before successful e2e validation is not allowed.

## Workflow State

Stage transitions happen by editing `.ai-dev-template.workflow-state.json`.

This supports safe returns to earlier stages without restoring deleted instruction files, for example:

- `deploy` -> `development`
- `e2e_test` -> `analysis`
- `e2e_test` -> `development`

## Configuration

Workflow policy is configured in `.ai-dev-template.config.json`.

The configuration governs language, execution mode, approval checkpoints, and PR/review behavior. It does not replace the explicit stage state stored in `.ai-dev-template.workflow-state.json`.

It also governs optional repository conventions such as `architecture.use_fsd`, which tells the template whether frontend work should explicitly follow Feature-Sliced Design.
