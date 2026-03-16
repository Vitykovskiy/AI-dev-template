# Workflow Configuration

## Purpose

`.ai-dev-template.config.json` is the workflow policy file for this repository.

Use it to decide how the agent should operate before project execution starts.

## Current Configuration Areas

- Language for docs, issues, PR text, and comments
- Execution mode: `autonomous`, `hybrid`, or `staged`
- Human approval checkpoints for high-risk changes
- PR, review, and merge policy
- Whether AI-generated artifacts are persisted to the repository
- How RAG is used in the development workflow
- Required and recommended GitHub token scopes

## Execution Modes

- `autonomous`: the agent may continue through the normal lifecycle without pausing on every stage, except for configured guardrails.
- `hybrid`: the agent is mostly autonomous, but must stop at configured human checkpoints.
- `staged`: the agent must pause for explicit confirmation between major stages.

## Guardrails

Guardrails are change categories that still require explicit human approval even when the execution mode is not fully staged.

Typical guardrails:

- architecture changes
- infrastructure changes
- schema migrations
- external integrations
- security-sensitive changes

## Pull Request Policy

If `pull_requests.enabled` is `false`, PR review and merge policy fields become informational only and must not drive the workflow.

If `pull_requests.enabled` is `true`, the repository should treat the following as policy:

- PRs are created only in the scope of a task, not for arbitrary unrelated changes
- a task branch is created for the task
- one or more commits may be created in that task branch
- the PR is opened when that task is ready for review or merge
- which tasks require a PR
- whether drafts are used first
- whether review is mandatory
- who reviews
- whether the agent must read and process PR comments
- merge strategy
- required approvals
- required green checks
- whether self-merge by the agent is allowed

`pull_requests.creation_mode` meanings:

- `for_every_task`: every task uses its own branch and its own PR
- `for_significant_tasks`: only tasks that are significant under repository policy use a PR
- `manual_per_task`: whether a task uses a PR is decided explicitly for that task

Significant tasks are tasks that meet at least one of the following:

- change application or infrastructure code
- change system behavior
- affect architecture, API, security, migrations, or external integrations
- require review under repository policy

Non-significant tasks are usually limited to documentation, text edits, or other small low-risk housekeeping changes that do not change system behavior.

## Artifact Persistence

Repository-persisted artifacts should remain the source of truth for reusable team knowledge.

Recommended to keep in the repository:

- `docs/`
- `AGENTS.md`
- architectural and operational decisions

Recommended to keep local only:

- scratch notes
- temporary task breakdown drafts
- temporary API dumps
- agent work logs
- experimental or intermediate generation files

Default local-only paths are listed in `.gitignore`.

## RAG / Vector DB Policy

Use `rag.mode` to define how RAG participates in the repository development workflow:

- `off`: do not use RAG in this repository
- `on_demand`: work without RAG by default, but allow enabling it later if direct context becomes insufficient
- `from_start`: prepare the development workflow to use RAG from the start

This policy is about agent workflow, not product architecture.

Even when RAG is allowed, vector DB remains optional infrastructure and still requires explicit user approval before activation.

## GitHub Token Requirements

Minimum expected scopes:

- `repo`
- `project`

Recommended additional scopes:

- `read:org`
- `workflow`

These scopes do not guarantee repository-specific write access or bypass branch protection rules. They only define the token capability baseline.
