# AI Dev Template

Template repository for projects where an AI agent runs a consistent discovery, planning, delivery, and documentation workflow.

## Purpose

This template gives every new project the same operating model:

- the repository is the source of truth for goals, requirements, architecture, decisions, workflow, and integrations;
- `.ai-dev-template.config.json` is the source of truth for workflow language, execution mode, and PR policy;
- GitHub Issues and GitHub Project are the source of truth for backlog, task status, and current execution;
- the agent must complete business task intake before planning implementation;
- important state must be persisted to repository artifacts and GitHub, not left in transient session context.

## What The Agent Automates

- Checks `git`, remotes, `gh`, authentication, and basic repository readiness.
- Reports missing prerequisites instead of silently working around them.
- Runs structured business task intake one topic block at a time.
- Documents the task, project scope, architecture, decisions, and workflow.
- Proposes a tech stack and records official best practices before implementation.
- Creates and maintains labels, Epic issues, task issues, and the GitHub Project board.
- Keeps documentation and delivery state synchronized.
- Adapts its workflow according to `.ai-dev-template.config.json`.

## What The Human Does Manually

Required manual steps:

1. Create a new GitHub repository from this template.
2. Clone the new repository locally.
3. Give the agent access to the repository workspace.
4. Create a GitHub Project manually.
5. Share the GitHub Project URL with the agent.
6. Share the business task in natural language.

The human does not need to create issues, labels, or move project cards manually.

## New Project Initialization

1. Create a new GitHub repository from this template.
2. Clone the repository locally.
3. Add `.ai-dev-template.config.json` to the repository root. Use the configurator for a guided setup:

   - [AI Dev Template Configurator](https://vitykovskiy.github.io/AI-dev-template-configurator/)

   The configurator walks through language policy, execution mode, and PR and review policy, then generates a ready config file.

4. Create a GitHub Project (simple kanban board — see below).
5. Provide the agent with the repository context, the GitHub Project URL, and the business task.

The agent handles the rest during Phase 1 (environment check, instructions adaptation, project map) and Phase 2 (business task intake).

## GitHub Project

Use a simple kanban board.

Required statuses:

- `Backlog`
- `In progress`
- `Closed`

Required fields:

- `Status`
- `Priority`
- `Area`

Operating rules:

- Labels are created by the agent.
- Issues are created by the agent.
- Project cards are moved by the agent.
- The human does not need to manually decompose work into tasks.

Store the actual GitHub Project URL in `docs/09-integrations.md`.

## Status Lifecycle

- `Backlog`: task is captured and ready for prioritization.
- `In progress`: task is actively being executed.
- `Closed`: task is implemented, documented, and reflected in GitHub state.

## Workflow Configuration

Workflow policy is configured in `.ai-dev-template.config.json`.

The configuration controls:

- docs / issue / PR / comment / commit language;
- execution mode: `autonomous`, `staged`;
- human approval checkpoints;
- task-scoped PR, review, and merge policy.

See `docs/11-workflow-configuration.md` for the detailed meaning of each section.

## Limitations And Assumptions

- This template assumes GitHub Issues, GitHub Project, and `gh` CLI are the delivery backbone.
- The template does not support GitHub Copilot instructions and intentionally excludes `.github/copilot-instructions.md`.
- `tasks/` may hold temporary local notes, but final state must be reflected in docs and GitHub.
- Labels remain canonically English in the default template configuration.
- Shell scripts are written for `bash`; `.gitattributes` pins LF for shell-sensitive files to prevent cross-platform EOL breakage.
