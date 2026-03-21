# Workflow

## Agent Working Cycle

1. Read mandatory context in the order defined by `AGENTS.md`.
2. Load workflow policy from `.ai-dev-template.config.json`.
3. Apply and acknowledge policy: fill in and show `templates/session-start-checklist.md` to the user. Every field must contain an actual value from `.ai-dev-template.config.json`. Do not proceed until the checklist is complete and visible.
4. Run environment check.
5. Perform business task intake.
<!-- IF:workflow.execution_mode=staged -->
6. Pause after intake and confirm with the user before continuing.
<!-- END IF -->
6. Persist intake results into docs.
7. Create Epic and tasks in GitHub.
<!-- IF:workflow.execution_mode=staged -->
8. Pause after task creation and confirm with the user before continuing.
<!-- END IF -->
8. Align stack and best practices.
9. Localize the relevant repository area using `docs/05-architecture.md`.
10. Execute tasks one by one. Before any implementation commit for each task: fill in `templates/task-start-checklist.md`. This checklist gates the human checkpoint check, PR classification, branch creation, and delivery mode statement. No implementation commit is allowed before the checklist is complete.
11. Finalize each task with persistence before context reset.

## Workflow Policy Inputs

The repository workflow is controlled by `.ai-dev-template.config.json`.

Minimum policy areas:

- language for docs, issues, PR text, comments, and commit messages
- execution mode
- PR / review / merge policy
- artifact persistence policy

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

## Execution Mode

<!-- IF:workflow.execution_mode=autonomous -->
**autonomous** — treat execution as a continuous delivery loop: after closing each task, immediately pick the next priority task from the backlog. Do not stop to report completion to the user between tasks. Stop only when a real blocker requires human input, a configured checkpoint is reached, or the backlog is exhausted.
<!-- END IF -->
<!-- IF:workflow.execution_mode=staged -->
**staged** — stop between every work stage and wait for explicit human confirmation before continuing.
<!-- END IF -->

<!-- IF:pull_requests.enabled=true -->
## Pull Request And Review Flow

PR flow is task-scoped.

Before the first implementation commit for a task, the agent must:

1. Classify the task as PR-required or not.
2. State the delivery mode explicitly.
3. If PR-required: create or switch to a task branch. Do not push to `main` directly.
4. If not PR-required: state that explicitly and justify against repository policy.

Recommended lifecycle:

1. Classify the task; confirm whether PR flow is required.
2. Create or update the task branch.
<!-- IF:pull_requests.draft_first=true -->
3. Open a draft PR first before the broader review and merge cycle.
<!-- END IF -->
3. Make implementation commits; run required checks; update docs.
4. Request review according to policy.
<!-- IF:pull_requests.review.agent_must_read_comments=true -->
5. Read all PR comments and review summaries before concluding review handling.
<!-- END IF -->
<!-- IF:pull_requests.review.agent_must_reply_to_comments=true -->
5. Reply to PR comments where the workflow expects a direct answer.
<!-- END IF -->
<!-- IF:pull_requests.review.agent_must_apply_accepted_feedback=true -->
5. Apply accepted review feedback before the PR is considered ready.
<!-- END IF -->
5. Merge only when all configured approvals and checks are satisfied.

**Review:**

<!-- IF:pull_requests.review.required=false -->
Review is not required.
<!-- END IF -->
<!-- IF:pull_requests.review.required=true -->
Review is required before merge.
<!-- END IF -->
<!-- IF:pull_requests.review.reviewers=human -->
Human review is required; agent self-review does not satisfy this.
<!-- END IF -->
<!-- IF:pull_requests.review.reviewers=ai -->
Agent review is the required path; record the result in the PR as a review comment or summary.
<!-- END IF -->
<!-- IF:pull_requests.review.reviewers=both -->
Both agent review and human review are required; record the agent review result in the PR before human review.
<!-- END IF -->

**Merge:**

<!-- IF:pull_requests.merge.require_green_checks=true -->
The PR is not merge-ready while required checks are failing or missing.
<!-- END IF -->
<!-- IF:pull_requests.merge.min_approvals!=0 -->
At least `{{pull_requests.merge.min_approvals}}` approval(s) required.
<!-- END IF -->
<!-- IF:pull_requests.merge.allow_agent_self_merge=false -->
The agent must not merge. Wait for an authorized actor.
<!-- END IF -->
<!-- IF:pull_requests.merge.allow_agent_self_merge=true -->
The agent may merge when all conditions are satisfied.
<!-- END IF -->
<!-- END IF -->

<!-- IF:pull_requests.enabled=false -->
## Delivery Without Pull Requests

Pull requests are disabled. Deliver tasks through direct commits to the main branch.

Track task completion through repository state, docs, GitHub Issues, and commits.
<!-- END IF -->


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

<!-- IF:pull_requests.enabled=true -->
The agent must also ensure that PR review comments were processed according to policy before considering the task complete.
<!-- END IF -->

## Known Limitations / Assumptions

- The template assumes the team uses GitHub Issues and GitHub Project rather than a separate backlog tool.
- Project board field names can vary by GitHub plan; the required logical fields remain `Status`, `Priority`, and `Area`.
- Shell automation assumes `bash` is available. On Windows, Git Bash or WSL is typically required.
- Some GitHub Project automations may still require repository-specific permissions that the agent cannot infer until environment check.
