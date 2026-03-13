# Workflow

## Agent Working Cycle

1. Read mandatory context in the order defined by `AGENTS.md`.
2. Run environment check.
3. Perform business task intake.
4. Persist intake results into docs.
5. Create Epic and tasks in GitHub.
6. Align stack and best practices.
7. Execute tasks one by one.
8. Finalize each task with persistence before context reset.

## Task Intake Phase

Mandatory intake sequence:

1. Context and current problem
2. Target result and business value
3. Users, scenarios, current process
4. Constraints, dependencies, first-version scope
5. Success and acceptance criteria
6. Risks, unknowns, open questions
7. Implementation options

Interaction rules:

- One semantic block at a time
- Short summary after each block
- No decomposition before intake is coherent
- No vector DB discussion during primary intake unless strictly needed

## Decomposition Rules

- Tasks must be atomic.
- Tasks must have a concrete expected result.
- Tasks must include completion criteria.
- Tasks must link dependencies when applicable.
- Tasks must map cleanly to GitHub Issue state.

## Task Status Movement

- New task: `Backlog`
- Active task: `In progress`
- Completed task: `Closed`

## Documentation Update Rules

- Requirement changes update `docs/02-business-requirements.md`.
- Scope changes update `docs/03-scope-and-boundaries.md`.
- Stack and official practices update `docs/04-tech-stack.md`.
- Architecture changes update `docs/05-architecture.md`.
- Material decisions update `docs/06-decision-log.md`.

## Finalize -> Persist -> Reset Context

Before the agent clears context after a task, it must:

1. persist code and documentation;
2. update the related issue;
3. update the project card;
4. update labels or status if needed;
5. create a dedicated commit;
6. verify that important state is not trapped in transient context.

## Known Limitations / Assumptions

- The template assumes the team uses GitHub Issues and GitHub Project rather than a separate backlog tool.
- Project board field names can vary by GitHub plan; the required logical fields remain `Status`, `Priority`, and `Area`.
- Shell automation assumes `bash` is available. On Windows, Git Bash or WSL is typically required.
- Vector DB guidance is generic by design and requires project-specific embedding decisions before activation.
- Some GitHub Project automations may still require repository-specific permissions that the agent cannot infer until environment check.
