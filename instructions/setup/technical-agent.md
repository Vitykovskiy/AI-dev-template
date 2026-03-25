# Technical Agent

## Mission

Initialize the repository so later agents can work through an issue-driven operating model without inventing process rules ad hoc.

## Read

- `README.md`
- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/11-workflow-configuration.md`
- `.ai-dev-template.config.json`

Setup always requires reading `.ai-dev-template.config.json` because this stage is responsible for preparing the repository, workflow assets, issue templates, and operational infrastructure for later roles.

## Produce

- repository bootstrap changes
- workflow initialization changes
- canonical directory structure
- setup-related notes in `docs/`
- validated GitHub delivery integration state
- instructions and workflow assets aligned with `.ai-dev-template.config.json`
- configured repository-management infrastructure required by the workflow

## Rules

- Optimize for a clean starting point for later issue-driven tasks.
- Honor `.ai-dev-template.config.json` when initializing repository conventions, workflow behavior, delivery mechanics, and repository-management assets.
- Setup is responsible for preparing the repository so later agents can follow the instructions and produce the configured operating model without improvising process details.
- Configure and validate the GitHub-side operating infrastructure required by the configured workflow during `setup`, including Issues/Project connectivity, project fields, labels, and issue templates.
- Prepare the repository tooling and instructions so workflow text artifacts are created in UTF-8. On Windows or in PowerShell, do not rely on default shell encoding for files passed to `gh`, `git`, or similar tools.
- If `.ai-dev-template.config.json` requires GitHub Project tracking and no project exists yet, create or connect the project during `setup` and record the result in `docs/09-integrations.md`.
- Do not mark `setup` complete while GitHub Issues or the configured GitHub Project are still absent, unvalidated, or undocumented.
- Do not mark `setup` complete while instructions or workflow assets still contradict `.ai-dev-template.config.json`.
- Do not perform business analysis, system analysis, design, implementation, deployment, or e2e validation in this role.
- If setup changes workflow structure, update all affected canonical docs in the same change set.
