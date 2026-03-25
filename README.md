# AI Dev Template

Template repository for an AI team that uses `setup` as a one-time bootstrap step and then runs all delivery through GitHub Issues, block-level delivery tasks, contour-owned child issues, and GitHub Project state.

## Operating Model

The template uses two workflow modes recorded in `.ai-dev-template.workflow-state.json`:

1. `setup` - technical agent initializes the repository, issue templates, labels, project structure, and workflow rules.
2. `issue_driven` - all post-setup work is routed by GitHub task metadata instead of a repository-wide stage chain.

After `setup`, GitHub Issues become the primary execution objects:

- an initiating Epic anchors the initiative;
- one `business_analysis` issue starts the initiative;
- one `system_analysis` issue produces the canonical specification package and decomposes delivery into parent `block_delivery` tasks;
- each `block_delivery` task represents one integrated deliverable and owns child implementation issues;
- every implementation issue has one owner contour and explicit dependencies;
- agents execute only tasks owned by their contour and only when task-linked inputs are sufficient;
- GitHub Project holds the canonical execution state for those issues.

## Core Principles

- No implementation before the required business-analysis, system-analysis, and design tasks are complete.
- `system_analysis` is the single source of truth for implementation inputs and block decomposition.
- User scenarios, interfaces, contracts, and acceptance expectations must exist before contour-owned implementation starts.
- Each task has exactly one owner contour.
- Cross-contour work must be split into linked tasks instead of one shared task.
- Missing specification is a blocker that routes work back to a linked `system_analysis` follow-up task instead of guesswork.
- `qa-e2e` validates integrated block-level outcomes, not isolated implementation issues.
- An initiative is not complete until required block-level validation, deploy work, and e2e tasks finish successfully.

## Repository Layout

- `AGENTS.md` - router that decides between `setup` and post-setup issue-driven routing.
- `.ai-dev-template.workflow-state.json` - bootstrap guardrail that records whether setup is still active.
- `instructions/` - setup instructions plus task-type and contour-specific instructions.
- `docs/analysis/` - canonical analysis package that gates design, implementation, deploy, and e2e work.
- `docs/delivery/` - block decomposition and contour handoff artifacts.
- `templates/` - reusable templates for initiative, analysis, design, implementation, deploy, and e2e tasks.
- `tasks/` - local scratch space only; not a durable backlog.

## How A New Project Starts

1. Create a repository from this template and clone it locally.
2. Add `.ai-dev-template.config.json` to the root.
3. Keep `.ai-dev-template.workflow-state.json` in the root with `current_stage = "setup"`.
4. Connect the repository to GitHub Issues and a GitHub Project board. If `project_tracking = github_project` and no project exists yet, create one before leaving `setup`.
5. Give the agent access to the repository and the business request.
6. Start with `AGENTS.md`; the router will either keep the repository in `setup` or switch to issue-driven routing after setup is validated.

## GitHub Workflow

GitHub Issues and GitHub Project are the operational backbone after setup.

Required GitHub Issue types:

- `initiative`
- `business_analysis`
- `system_analysis`
- `block_delivery`
- `design`
- `implementation`
- `deploy`
- `e2e`

Required task attributes:

- task type
- owner contour
- parent initiative
- explicit dependencies
- definition of ready
- definition of done
- canonical inputs
- GitHub Project status

Required GitHub Project statuses:

- `Inbox`
- `Ready`
- `In Progress`
- `Blocked`
- `Waiting for Testing`
- `Testing`
- `Waiting for Fix`
- `In Review`
- `Done`

Completed task handoffs must have verified evidence. Repository changes must be committed and pushed, and required GitHub-side workflow actions must be verified before completion is reported. When pull requests are disabled, the agent pushes directly to the assigned working branch.

Workflow text artifacts should be written in UTF-8. On Windows and in PowerShell, files passed to `gh`, `git`, or similar tools must use explicit UTF-8 encoding to avoid corrupted non-ASCII text.

## Bootstrap Guardrail

`.ai-dev-template.workflow-state.json` remains in the repository as a lightweight guardrail:

- `setup` blocks operational work until the repository and GitHub operating model are ready;
- `issue_driven` means setup is complete and no global post-setup stage transitions are allowed.

The file no longer represents a sequential lifecycle after setup.

## Configuration

Workflow policy is configured in `.ai-dev-template.config.json`.

The configuration governs language, execution mode, approval checkpoints, and PR/review behavior. It does not replace task ownership, dependencies, or GitHub Project state.

It also governs optional repository conventions such as `architecture.use_fsd`, which tells the template whether frontend work should explicitly follow Feature-Sliced Design.
