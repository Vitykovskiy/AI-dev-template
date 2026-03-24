# AI Dev Template

Template repository for an AI team that works through a fixed phase-and-role workflow instead of improvising discovery, design, implementation, deployment, and validation in one session.

## Operating Model

The template enforces a 6-stage lifecycle:

1. `setup` — technical agent initializes the repository and workflow.
2. `intake` — business analyst captures the problem, users, scenarios, scope, and acceptance expectations.
3. `analysis` — system analyst produces the implementation-ready specification package.
4. `delivery` — contour-specific roles implement only their assigned slice, such as `frontend`, `backend`, or contour-specific `devops`.
5. `deploy` — devops rolls the delivered contours into the target environment.
6. `e2e-test` — qa-e2e validates the deployed system against user scenarios and acceptance criteria.

The repository is the canonical source of truth for:

- workflow routing and role rules;
- business context and user scenarios;
- system analysis and integration contracts;
- contour decomposition and lifecycle state;
- architecture, decisions, and operational knowledge.

## Core Principles

- No implementation before analysis is sufficient for delivery.
- User scenarios are fixed before contour decomposition.
- Screens, interfaces, data formats, and integration contracts are analyzed before coding.
- Frontend works from its own contour specification and contracts, not by reading backend code.
- Backend works from its own contour specification and contracts, not by reading frontend code.
- Missing specification is a blocker that returns the initiative to `analysis`.
- An initiative is not complete until deployment and e2e validation both succeed.

## Repository Layout

- `AGENTS.md` — router that selects the current stage and role branch.
- `instructions/` — stage-specific and role-specific instructions.
- `docs/analysis/` — canonical analysis package that gates delivery.
- `docs/delivery/` — contour decomposition and delivery handoff artifacts.
- `templates/` — reusable templates for intake, analysis, contour delivery, deploy, and e2e work.
- `tasks/` — local scratch space only; not a durable backlog.

## How A New Project Starts

1. Create a repository from this template and clone it locally.
2. Add `.ai-dev-template.config.json` to the root.
3. Connect the repository to GitHub Issues and a GitHub Project board.
4. Give the agent access to the repository and the business request.
5. Start with `AGENTS.md`; the router will select `setup` or `intake` depending on repository state.

## GitHub Workflow

GitHub Issues and GitHub Project remain the operational backbone, but task creation follows the lifecycle:

- intake captures the initiative;
- analysis produces implementation-ready artifacts;
- delivery creates contour-specific tasks;
- deploy and e2e-test run as separate stages after implementation.

Closing an initiative before successful e2e validation is not allowed.

## Configuration

Workflow policy is configured in `.ai-dev-template.config.json`.

The configuration governs language, execution mode, approval checkpoints, and PR/review behavior. It does not replace the phase-and-role lifecycle defined in `AGENTS.md`, `instructions/`, and `docs/07-workflow.md`.
