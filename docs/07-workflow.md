# Workflow

## Agent Working Cycle

1. Read mandatory context in the order defined by `AGENTS.md`.
2. Load workflow policy from `.ai-dev-template.config.json`.
3. Apply and acknowledge policy: fill in and show `templates/session-start-checklist.md` to the user. Every field must contain an actual value from `.ai-dev-template.config.json`. Do not proceed until the checklist is complete and visible.
4. Run environment check.
5. Perform business task intake. If `execution_mode` is `staged`, pause after intake and confirm with the user before continuing to step 6.
6. RAG activation checkpoint: if `rag.mode` is `from_start`, explicitly raise and resolve the RAG question before continuing. Cover whether RAG is justified now or should be deferred, which embedding provider or model would be used, and which `.env` values are required. Record the outcome in `docs/08-vector-db.md`. This step is mandatory and blocks progression to step 7.
7. Persist intake results into docs.
8. Create Epic and tasks in GitHub. If `execution_mode` is `staged`, pause after task creation and confirm with the user before continuing to step 9.
9. Align stack and best practices.
10. Localize the relevant repository area using `docs/05-architecture.md`.
11. Execute tasks one by one. Before any implementation commit for each task: fill in `templates/task-start-checklist.md`. This checklist gates the human checkpoint check, PR classification, branch creation, and delivery mode statement. No implementation commit is allowed before the checklist is complete.
12. Finalize each task with persistence before context reset.

## Workflow Policy Inputs

The repository workflow is controlled by `.ai-dev-template.config.json`.

Minimum policy areas:

- language for docs, issues, PR text, comments, and commit messages
- execution mode
- human approval checkpoints
- PR / review / merge policy
- artifact persistence policy
- RAG policy

If repository language is Russian, repository artifacts should be written in clear Russian and should not contain avoidable mixed-language wording.

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

## Code Navigation Before Changes

Before reading implementation files in depth or changing code:

1. determine which repository area the task belongs to;
2. use `docs/05-architecture.md` as the structure map;
3. search the relevant area first;
4. avoid bringing unrelated areas into context unless they are required by the task.

For monorepos, determine `where to work` before deciding `what to change`.

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

Before the first implementation commit for a task, the agent must:

1. classify the task as PR-required or not;
2. choose the delivery mode for that task;
3. verify that the current branch matches repository policy;
4. only then continue with implementation commits.

That means:

1. the agent picks a task;
2. creates or updates the branch for that task;
3. makes one or more commits for that task;
4. opens the PR when the task is ready according to policy.

Recommended lifecycle:

1. classify the task and confirm whether PR flow is required;
2. create or update the task branch;
3. make the branch ready for PR creation;
4. open a draft PR first if configured before the broader review and merge cycle;
5. run required checks and update docs;
6. request review according to policy;
7. read PR comments and review summaries;
8. apply accepted feedback;
9. merge only when the configured approvals and checks are satisfied.

Operational review and merge interpretation:

- if review is required, the task is not merge-ready before review policy is satisfied;
- if reviewer type is `human`, human review is required;
- if reviewer type is `ai`, the agent must perform the review step itself and record the review result in the PR;
- if reviewer type is `both`, both the agent review step and human review are required, and the agent review result must be recorded in the PR;
- if comment-reading or reply handling is enabled, the agent must process PR comments before concluding review handling;
- if accepted feedback must be applied, the agent must not leave accepted review feedback unresolved;
- if green checks are required, the PR is not merge-ready while required checks are failing or missing;
- if self-merge by the agent is disabled, the agent must stop before merge and wait for an allowed actor.

`pull_requests.creation_mode` meanings:

- `for_every_task`: use a PR for every task
- `for_significant_tasks`: use a PR only for tasks that are significant enough to require one
- `manual_per_task`: use a PR only after an explicit human decision for that task

Significant tasks are tasks that:

- change application or infrastructure code
- change system behavior
- affect architecture, API, security, migrations, or external integrations
- require review under repository policy

Documentation-only tasks, text fixes, and small low-risk housekeeping changes are usually not significant unless the repository defines otherwise.

If `pull_requests.enabled` is `true` and the task is significant, implementation commits must not go directly to `main`.

If the agent chooses to work without a PR for a task, it must state that decision explicitly before the first implementation commit and justify it against repository policy.

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
