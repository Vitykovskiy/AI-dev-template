# Decision Log

Use ADR-lite entries. Add new decisions to the top.

## 2026-03-25 - Replace post-setup stage flow with issue-driven routing

- Decision: Keep `.ai-dev-template.workflow-state.json` only as a bootstrap guardrail with `setup` and `issue_driven`, and route all post-setup work through GitHub Issue metadata, dependencies, owner contours, and GitHub Project state.
- Reason: Global post-setup stages allowed premature advancement and weak ownership boundaries. Issue-driven routing makes blockers, ownership, and readiness explicit and verifiable.
- Consequences: Issue templates, project fields, routing docs, and task checklists must carry the required task metadata. Agents may no longer advance work by editing a repository-wide stage file after setup.

## 2026-03-13 - Establish template operating model

- Decision: Use repository docs as the source of truth for project context and GitHub Issues plus GitHub Project as the source of truth for delivery state.
- Reason: New agent sessions must be able to resume work predictably without relying on transient context.
- Consequences: Documentation and issue hygiene become mandatory parts of task completion.

## 2026-03-16 - Add configurable workflow policy

- Decision: Introduce `.ai-dev-template.config.json` as the workflow policy file for language, execution mode, PR policy, and artifact persistence.
- Reason: The template must support different collaboration models without hardcoding one fixed operating mode.
- Consequences: Agent behavior, docs, and setup scripts must honor the configuration before project execution starts.
