# Phase 3 — Delivery

This file was adapted by the agent during Phase 1 to match the specific project configuration.

---

## Session Start

At the beginning of every new session, complete in order:

1. Read `AGENTS.md`.
2. Read `.ai-dev-template.config.json`.
3. Read current documentation:
   - `docs/00-project-overview.md`
   - `docs/01-product-vision.md`
   - `docs/02-business-requirements.md`
   - `docs/04-tech-stack.md`
   - `docs/05-architecture.md`
4. Check open GitHub Issues.
5. Check GitHub Project board state.
<!-- IF:project_map.enabled=true -->
6. Read `docs/project-map.md` to restore project structure context.
<!-- END IF -->

<!-- IF:workflow.execution_mode=staged -->
After reviewing project state — stop and wait for explicit human confirmation before continuing.
<!-- END IF -->

**Execution mode: `{{workflow.execution_mode}}`**

<!-- IF:workflow.execution_mode=autonomous -->
Work iteratively through tasks without pausing between stages. Continue until a configured human checkpoint is reached, a blocker requires input, or the backlog is exhausted.
<!-- END IF -->
<!-- IF:workflow.execution_mode=staged -->
Stop after each work stage and wait for explicit human confirmation before continuing.
<!-- END IF -->

---

## Decomposition Rules

Every task must:

- be atomic;
- produce one clear outcome;
- include completion criteria;
- include dependencies when they exist;
- avoid bundling unrelated goals.

New tasks start in `Backlog`.

The agent must not create execution tasks before the intake result is coherent enough to support Definition of Ready.

---

## GitHub Issues And GitHub Project Rules

- New tasks go to `Backlog`.
- A picked-up task moves to `In Progress`.
- A finished task moves to `Closed`.
- The agent keeps the board current.
- The agent creates and maintains labels.

Minimum required labels:

- `type: epic`
- `type: feature`
- `type: bug`
- `type: task`
- `area: frontend`
- `area: backend`
- `area: infra`
- `area: docs`
- `area: data`
- `priority: high`
- `priority: medium`
- `priority: low`
- `status: blocked`
- `status: needs-info`

---

## External Library Rules

Before working with an external library, framework, SDK, or internal shared library — do not rely on memory or assumptions.

Required validation order:

1. Check local documentation in the repository.
2. Check existing usage examples in the codebase.
3. Check the connected official documentation source.
4. If confirmation is still missing — mark the uncertainty explicitly and do not invent a solution.

---

<!-- IF:pull_requests.enabled=false -->
## Delivery Without Pull Requests

Pull requests are disabled. Deliver tasks through direct commits to the main branch.

Track task completion through repository state, documentation, Issues, and commits.

<!-- END IF -->

<!-- IF:pull_requests.enabled=true -->
## Pull Request Rules

Pull requests are enabled. PR flow is task-scoped.

Before the first implementation commit for each task:

1. Classify the task: does it require a PR under repository policy.
2. State the delivery mode explicitly before the first implementation commit.
3. If PR required: create or switch to a task branch. Do not push implementation commits directly to `main`.
4. If PR not required: state that explicitly and justify against repository policy.

**PR creation policy: `{{pull_requests.creation_mode}}`**

<!-- IF:pull_requests.creation_mode=for_every_task -->
Every task uses its own branch and PR.
<!-- END IF -->
<!-- IF:pull_requests.creation_mode=for_significant_tasks -->
A PR is required only for significant tasks. Significant tasks are those that change application or infrastructure code, change system behavior, or affect architecture, API, security, migrations, or external integrations. Documentation-only tasks and small low-risk changes are not significant unless the repository defines otherwise.
<!-- END IF -->
<!-- IF:pull_requests.creation_mode=manual_per_task -->
Whether a task requires a PR is determined by an explicit human decision for each task. Do not decide silently — ask for or obtain an explicit human decision before treating the task as PR-free.
<!-- END IF -->

**Review policy:**

<!-- IF:pull_requests.review.required=false -->
Review is not required. The PR may be merged when all other merge conditions are satisfied.
<!-- END IF -->
<!-- IF:pull_requests.review.required=true -->
Review is required. Do not treat the task as merge-ready before review requirements are satisfied.
<!-- END IF -->

<!-- IF:pull_requests.review.reviewers=human -->
Human review is required. Agent self-review does not satisfy this.
<!-- END IF -->
<!-- IF:pull_requests.review.reviewers=ai -->
Agent review is the required review path. Record the review result in the PR as a summary or comment before merging.
<!-- END IF -->
<!-- IF:pull_requests.review.reviewers=both -->
Both agent review and human review are required. Record the agent review result in the PR before human review begins.
<!-- END IF -->

<!-- IF:pull_requests.review.agent_must_read_comments=true -->
Read all PR comments and review summaries before concluding review handling.
<!-- END IF -->
<!-- IF:pull_requests.review.agent_must_reply_to_comments=true -->
Reply to PR comments where the workflow expects a direct answer.
<!-- END IF -->
<!-- IF:pull_requests.review.agent_must_apply_accepted_feedback=true -->
Apply accepted review feedback before considering the PR ready for merge.
<!-- END IF -->

**Merge policy:**

<!-- IF:pull_requests.merge.squash_commits=true -->
Task commits are squashed into one before merge.
<!-- END IF -->
<!-- IF:pull_requests.merge.squash_commits=false -->
Task commits are preserved individually on merge.
<!-- END IF -->
<!-- IF:pull_requests.merge.integration_method=merge -->
Branch integration is done through a merge commit.
<!-- END IF -->
<!-- IF:pull_requests.merge.integration_method=rebase -->
Branch integration is done through rebase.
<!-- END IF -->
<!-- IF:pull_requests.merge.require_green_checks=true -->
Do not treat the PR as merge-ready while required checks are failing or missing.
<!-- END IF -->
<!-- IF:pull_requests.merge.min_approvals!=0 -->
At least `{{pull_requests.merge.min_approvals}}` approval(s) required before merge.
<!-- END IF -->
<!-- IF:pull_requests.merge.allow_agent_self_merge=false -->
The agent must not merge the PR. Stop before merge and wait for an authorized actor.
<!-- END IF -->
<!-- IF:pull_requests.merge.allow_agent_self_merge=true -->
The agent may merge the PR when all configured conditions are satisfied.
<!-- END IF -->
<!-- IF:pull_requests.merge.agent_configure_branch_protection=true -->
Before any implementation work begins, configure branch protection on the main branch via the GitHub API. Required rules: require pull request before merging, set minimum approvals per `pull_requests.merge.min_approvals`, disable bypassing protection. Requires admin access to the repository.
<!-- END IF -->

<!-- END IF -->

---

<!-- IF:project_map.enabled=true -->
## Project Map

`docs/project-map.md` is the current map of the project file structure. The map must contain a file tree with a brief description of each folder's purpose and each key file.

Before searching the project — read the map if it exists.

Update the map whenever the structure changes (files or folders added, removed, or moved). Updating the map is a mandatory task completion step if the structure changed.
<!-- END IF -->

---

## Documentation Rules

- Any significant decision must be recorded in `docs/`.
- Requirement changes must update `docs/02-business-requirements.md`.
- Architecture changes must update `docs/05-architecture.md` and `docs/06-decision-log.md`.
- Stack changes must update `docs/04-tech-stack.md`.
- Workflow changes must update `docs/07-workflow.md`.
- Workflow policy changes must update `.ai-dev-template.config.json` and `docs/11-workflow-configuration.md` when the meaning changes.

---

## Definition Of Ready

A task is ready only when the following are clear:

- goal;
- input data;
- boundaries;
- dependencies;
- completion criteria;
- expected outcome.

---

## Definition Of Done

A task is done only when:

- the required result exists;
- documentation is updated;
- issue state is updated;
- GitHub Project status is updated;
- important decisions are recorded;
- new risks or limitations are recorded;
- a dedicated git commit is created for the task.

<!-- IF:pull_requests.enabled=true -->
Task completion also requires compliance with the configured PR, review, and merge policy.
<!-- END IF -->

If no project-specific commit standard exists, use Conventional Commits and include the issue reference in the header or body. The commit message language must follow `.ai-dev-template.config.json`.

---

## Task Finalization Order

After each completed task, follow this order:

1. Persist the result in canonical sources.
2. Update documentation.
3. Update the related Issue.
4. Update the GitHub Project card.
5. Update labels or status if needed.
<!-- IF:project_map.enabled=true -->
6. If project structure changed — update `docs/project-map.md`.
<!-- END IF -->
7. Create a dedicated commit for the task.
8. Ensure no significant state exists only in session context.
9. Only then reset or clear working context.

<!-- IF:pull_requests.enabled=true -->
If a PR is open: task completion also includes completing the full review and merge cycle per repository policy.
<!-- END IF -->
