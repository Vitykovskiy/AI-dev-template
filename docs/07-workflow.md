# Workflow

## Agent Working Cycle

1. Read mandatory context in the order defined by `AGENTS.md`.
2. Load workflow policy from `.ai-dev-template.config.json`.
3. Run environment check.
4. Perform business task intake.
5. Persist intake results into docs.
6. Create Epic and tasks in GitHub.
7. Align stack and best practices.
8. Execute tasks one by one.
9. Finalize each task with persistence before context reset.

## Workflow Policy Inputs

The repository workflow is controlled by `.ai-dev-template.config.json`.

Minimum policy areas:

- language for docs, issues, PR text, and comments
- execution mode
- human approval checkpoints
- PR / review / merge policy
- artifact persistence policy
- RAG policy

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
- If execution mode is `staged`, pause after intake before moving into task creation

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

## Execution Modes

- `autonomous`: the agent may continue without stage-by-stage approval unless it reaches a configured human checkpoint.
- `hybrid`: the agent continues normally, but must stop at configured human checkpoints.
- `staged`: the agent must stop between work stages and also stop at configured human checkpoints.

## Pull Request And Review Flow

Apply this section only when pull requests are enabled in `.ai-dev-template.config.json`.

PR flow is task-scoped.

That means:

1. the agent picks a task;
2. creates or updates the branch for that task;
3. makes one or more commits for that task;
4. opens the PR when the task is ready according to policy.

Recommended lifecycle:

1. create or update the task branch;
2. open a draft PR first if configured;
3. run required checks and update docs;
4. request review according to policy;
5. read PR comments and review summaries;
6. apply accepted feedback;
7. merge only when the configured approvals and checks are satisfied.

`pull_requests.creation_mode` meanings:

- `for_every_task`: use a PR for every task
- `for_significant_tasks`: use a PR only for tasks that are significant enough to require one
- `manual_per_task`: decide task by task whether a PR is needed

Significant tasks are tasks that:

- change application or infrastructure code
- change system behavior
- affect architecture, API, security, migrations, or external integrations
- require review under repository policy

Documentation-only tasks, text fixes, and small low-risk housekeeping changes are usually not significant unless the repository defines otherwise.

If pull requests are disabled, completion is tracked through repository state, docs, issues, and commits instead.

## Human Checkpoints

Human checkpoints are the configured categories of changes that require human approval even in non-staged workflows.

Typical examples:

- architecture changes
- infrastructure changes
- schema migrations
- external integrations
- security-sensitive changes

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

If pull requests are enabled, the agent must also ensure that PR review comments were processed according to policy before considering the task complete.

## Known Limitations / Assumptions

- The template assumes the team uses GitHub Issues and GitHub Project rather than a separate backlog tool.
- Project board field names can vary by GitHub plan; the required logical fields remain `Status`, `Priority`, and `Area`.
- Shell automation assumes `bash` is available. On Windows, Git Bash or WSL is typically required.
- Vector DB guidance is generic by design and requires project-specific embedding decisions before activation.
- Some GitHub Project automations may still require repository-specific permissions that the agent cannot infer until environment check.
