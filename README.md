# AI Dev Template

Template repository for projects where an AI agent runs a consistent discovery, planning, delivery, and documentation workflow.

## Purpose

This template gives every new project the same operating model:

- the repository is the source of truth for goals, requirements, architecture, decisions, workflow, integrations, and vector DB configuration;
- `.ai-dev-template.config.json` is the source of truth for workflow language, execution mode, PR policy, artifact persistence, and RAG policy;
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
- Offers vector DB only after task intake and environment alignment are complete.
- Starts the optional vector DB stack after explicit user approval and `.env` setup.

## What The Human Does Manually

Required manual steps:

1. Create a new GitHub repository from this template.
2. Clone the new repository locally.
3. Give the agent access to the repository workspace.
4. Create a GitHub Project manually.
5. Share the GitHub Project URL with the agent.
6. Share the business task in natural language.
7. If the agent later proposes vector DB and you agree, fill secrets into `.env` based on agent instructions.

The human does not need to create issues, labels, or move project cards manually.

## New Project Initialization

```bash
git clone https://github.com/<org>/<repo>.git
cd <repo>
bash scripts/bootstrap.sh
```

Recommended next commands:

```bash
bash scripts/check-environment.sh
bash scripts/check-github-permissions.sh
```

Then provide the agent with:

1. The repository context.
2. The GitHub Project URL.
3. The business task.

Before active delivery starts, review and update `.ai-dev-template.config.json`.

If you want a faster setup flow, use the configurator:

- [AI Dev Template Configurator](https://vitykovskiy.github.io/AI-dev-template-configurator/)

The configurator helps you choose workflow language for docs, issues, PRs, comments, and commits, plus execution mode, PR policy, artifact persistence, and RAG mode, then generates a ready `.ai-dev-template.config.json` for the repository root.

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
- execution mode: `autonomous`, `hybrid`, `staged`;
- human approval checkpoints;
- task-scoped PR, review, and merge policy;
- whether temporary AI work artifacts stay local or are persisted;
- how RAG is used in the development workflow.

See `docs/11-workflow-configuration.md` for the detailed meaning of each section.

## Optional Vector DB

Vector DB is optional infrastructure, not a default part of project setup.

The agent may propose it only after:

1. business task intake is finished;
2. environment readiness is checked;
3. the use case justifies semantic retrieval or indexing.

If you agree:

1. the agent asks which embedding provider or model to use;
2. the decision is recorded in `docs/08-vector-db.md`;
3. you create `.env` from `.env.example` and fill it;
4. the agent starts `docker-compose.vector-db.yml`.

The template supports multiple embedding strategies:

- OpenAI;
- another hosted embedding provider;
- a local embedding model;
- no vector DB at all.

## Limitations And Assumptions

- This template assumes GitHub Issues, GitHub Project, and `gh` CLI are the delivery backbone.
- The template does not support GitHub Copilot instructions and intentionally excludes `.github/copilot-instructions.md`.
- Vector DB compose is provided up front, but it must not be enabled without explicit user agreement.
- `tasks/` may hold temporary local notes, but final state must be reflected in docs and GitHub.
- Labels remain canonically English in the default template configuration.
- Shell scripts are written for `bash`; `.gitattributes` pins LF for shell-sensitive files to prevent cross-platform EOL breakage.
