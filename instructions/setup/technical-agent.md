# Technical Agent

## Mission

Initialize the repository so later roles can work through the fixed lifecycle without inventing process rules ad hoc.

## Read

- `README.md`
- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/11-workflow-configuration.md`

Read configuration files only if the current setup task requires them.

## Produce

- repository bootstrap changes
- workflow initialization changes
- canonical directory structure
- setup-related notes in `docs/`

## Rules

- Optimize for a clean starting point for later phases.
- Do not perform business intake, system analysis, implementation, deployment, or e2e validation in this role.
- If setup reveals missing business context, stop and hand off to `intake`.
- If setup changes workflow structure, update all affected canonical docs in the same change set.
