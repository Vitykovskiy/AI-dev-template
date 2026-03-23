# Phase 3 — Delivery

This file was adapted by the agent during Phase 1 to match the specific project configuration.

---

## Session Start

At the beginning of every new session, complete in order:

1. Read `AGENTS.md`.
2. Read `.ai-dev-template.config.json`.
3. Read current documentation — only what is directly relevant to the task you are about to pick up:
   - `docs/00-project-overview.md` — always
   - `docs/01-product-vision.md` — always
   - `docs/02-business-requirements.md` — always
   - `docs/04-tech-stack.md` — only if the task touches stack choices or new dependencies
   - `docs/05-architecture.md` — only if the task touches system structure or cross-service interactions
   - `docs/08-code-style.md` — only if the task involves writing or modifying code
   - `docs/external-libraries.md` — only if the task uses a library listed there
   - `docs/internal-libraries.md` — only if the task uses a shared internal module
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
Treat execution as a continuous delivery loop: after closing each task, immediately pick the next priority task from the backlog. Do not stop to report completion to the user between tasks. Stop only when a real blocker requires human input, a configured checkpoint is reached, or the backlog is exhausted.

**Critical rule:** do not announce that you are continuing — execute the first concrete action of the next task immediately. Declaring intent to continue without performing an action is equivalent to stopping.
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

**One task — one area.** A task must carry exactly one `area:` label. If a feature requires work in multiple contours (e.g. both `area: backend` and `area: frontend`) — create a separate task for each contour and link them via Dependencies. The backend task comes first; the frontend task lists it as a dependency.

Example — correct decomposition of a feature spanning two contours:
```
[Task] Implement order queue API and lifecycle statuses  →  area: backend
[Task] Implement order queue UI for barista              →  area: frontend, depends on: backend task
```

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

Priority criteria — assign exactly one per task:

- `priority: high` — blocks launch or blocks another task from starting; the project cannot move forward without it.
- `priority: medium` — required for a complete v1 but does not block parallel work; can be picked up after high-priority tasks.
- `priority: low` — improvement or nice-to-have; safe to defer past the initial release without harming core functionality.

If multiple tasks seem equally urgent, prefer `priority: medium` as the default. Reserve `priority: high` only for genuine blockers.

---

## Context Management

Context is a finite resource. Every file read stays in context for the entire session. Treat context like memory: load only what the current task actually needs.

**Rules:**

1. **Read on demand, not upfront.** Do not read a file unless its content will directly affect a decision in the current task. Curiosity reads waste context.
2. **Read large files in fragments.** For files longer than 300 lines, read only the relevant section. If you need the whole file, state why explicitly before reading it.
3. **Do not re-read files already in context.** If a file was read earlier in the session, refer to what is already known.
4. **Contracts and specs are task-scoped.** If the project contains large API contracts, UI specs, or data schemas — load only the module or section relevant to the current task, not the entire file.
5. **Decompose monolithic artifacts before use.** If a file in the project exceeds 300 lines and covers multiple independent concerns (e.g. a single JSON contract for the entire UI), split it into per-feature or per-module files before working with it. Do this as an explicit step, not silently.

---

## Code Style Rules

Before writing or modifying any code, read `docs/08-code-style.md`.

Apply all rules from that file throughout the task. Before closing a task:

1. Check every new or modified file against the size limits defined in `docs/08-code-style.md`.
2. If a file, component, or function exceeds a limit — decompose it before closing the task. Do not defer decomposition to a follow-up task.
3. If a new pattern or convention was established during the task — update `docs/08-code-style.md` to record it.

---

## External Library Rules

Before working with an external library, framework, SDK, or internal shared library — do not rely on memory or assumptions.

Required validation order:

1. Check `docs/external-libraries.md` or `docs/internal-libraries.md` first.
2. Check existing usage examples in the codebase.
3. Check the connected official documentation source.
4. If confirmation is still missing — mark the uncertainty explicitly and do not invent a solution.

When a new external dependency is added or an existing one is upgraded — update `docs/external-libraries.md` before closing the task. When a new shared module is introduced or its contract changes — update `docs/internal-libraries.md` before closing the task.

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
Review is performed by the veni-vidi-review GitHub App, which is triggered automatically on PR open. Wait for the external review result before merging.
<!-- END IF -->

<!-- IF:pull_requests.review.reviewers=ai,pull_requests.merge.allow_agent_self_merge=true -->
**AI review gate:** after opening the PR or pushing a new commit, follow this exact sequence:

1. Record the current `head sha` immediately after the push.
2. Identify the GitHub Actions run for `.github/workflows/ai-review-gate.yml` that is associated with that `head sha`. Use `gh run list --workflow=ai-review-gate.yml --branch=<branch>` and match by `headSha`.
3. Wait for that specific run to reach a terminal state. Terminal states are: `success`, `failure`, `timed_out`. The states `in_progress`, `queued`, and `waiting` are not terminal — keep waiting.
4. `cancelled` and `skipped` are not failures. They mean the run was superseded by a newer push. In that case, go back to step 2 and find the run for the current `head sha`.
5. While the run is `in_progress` or `queued`: do not re-request review, do not open a new review request, do not declare a blocker. Any of these actions will cancel the current run and restart the cycle.
6. Polling interval: wait at least 30 seconds between status checks. Stop polling after 15 minutes of continuous `in_progress`/`queued` state — only then treat it as a timeout blocker requiring human input.
7. If the run completes with `success`: the `ai-review-approved` check passes — proceed to merge when all other conditions are satisfied.
8. If the run completes with `failure`: read all new review comments posted on the current `head sha`. Address the feedback, push a fix commit, then return to step 1.

Do not use `reviewDecision` or GitHub approval count — the App has `authorAssociation=NONE` and its approval does not count toward branch protection.
<!-- END IF -->
<!-- IF:pull_requests.review.reviewers=both -->
Both agent review and human review are required. Record the agent review result in the PR before human review begins.
<!-- END IF -->

Read all PR comments and review summaries before concluding review handling.

Reply to PR comments where the workflow expects a direct answer.

Apply accepted review feedback before considering the PR ready for merge.

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
<!-- IF:pull_requests.review.required=true,pull_requests.review.reviewers=human -->
At least 1 approval required before merge.
<!-- END IF -->
<!-- IF:pull_requests.review.required=true,pull_requests.review.reviewers=both -->
At least 1 approval required before merge.
<!-- END IF -->
<!-- IF:pull_requests.review.required=true,pull_requests.review.reviewers=ai -->
The `ai-review-approved` required status check must pass before merge. Do not rely on GitHub approval count — the GitHub App's review does not count as a qualifying approval in branch protection.
<!-- END IF -->
<!-- IF:pull_requests.merge.allow_agent_self_merge=false -->
The agent must not merge the PR. Stop before merge and wait for an authorized actor.
<!-- END IF -->
<!-- IF:pull_requests.merge.allow_agent_self_merge=true -->
The agent may merge the PR when all configured conditions are satisfied.
<!-- END IF -->
<!-- IF:pull_requests.merge.agent_configure_branch_protection=true,pull_requests.review.reviewers=ai -->
Before any implementation work begins:
1. Configure branch protection on the main branch via the GitHub API. Required rules: require pull request before merging, required status checks: `ai-review-approved` (strict), minimum approvals: 0, disable bypassing protection. Requires admin access to the repository.
2. Verify that `.github/workflows/ai-review-gate.yml` is present in the repository — this workflow implements the `ai-review-approved` check.
<!-- END IF -->
<!-- IF:pull_requests.merge.agent_configure_branch_protection=true,pull_requests.review.reviewers=human -->
Before any implementation work begins:
1. Configure branch protection on the main branch via the GitHub API. Required rules: require pull request before merging, set minimum approvals to 1, disable bypassing protection. Requires admin access to the repository.
2. If `.github/workflows/ai-review-gate.yml` exists in the repository — delete it. It is only needed for AI review workflows.
<!-- END IF -->
<!-- IF:pull_requests.merge.agent_configure_branch_protection=true,pull_requests.review.reviewers=both -->
Before any implementation work begins, configure branch protection on the main branch via the GitHub API. Required rules: require pull request before merging, set minimum approvals to 1, disable bypassing protection. Requires admin access to the repository.
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

**Commit message quality rule:** the subject line must describe what changed from the product perspective, not how it was implemented technically. The subject line is the changelog. Write it so a non-technical stakeholder can understand what was delivered.

- Good: `feat: корзина с поддержкой модификаторов товаров (#4)`
- Bad: `feat: реализовать модель каталога и допов (#4)`
- Good: `fix: заказ больше не теряется при пустом слоте (#7)`
- Bad: `fix: исправить NPE в CartService при null pickup slot (#7)`

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
