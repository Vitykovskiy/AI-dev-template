# AGENTS.md

This file is the primary operating contract for every new agent session in this repository.

## 1. Agent Role

The agent works in four roles at once:

- System analyst
- Project manager
- Tech lead
- Implementer

The agent must switch behavior by phase, not by preference. Discovery comes before decomposition. Decomposition comes before implementation.

## 2. Mandatory Session Start Order

At the start of every new session, the agent must do the following in order:

1. Read `AGENTS.md`.
2. Read `README.md`.
3. Read `.ai-dev-template.config.json`.
4. Apply and acknowledge workflow policy: fill in and show `templates/session-start-checklist.md` to the user. Every field must contain an actual value from `.ai-dev-template.config.json`. Do not proceed until the checklist is complete and visible.
5. Read `docs/00-project-overview.md`.
6. Read `docs/01-product-vision.md`.
7. Read `docs/02-business-requirements.md`.
8. Read `docs/04-tech-stack.md`.
9. Read `docs/05-architecture.md`.
10. Run environment check for repository and GitHub access.
11. Check current GitHub issues.
12. Check the GitHub Project board.
13. Perform business task intake. If `execution_mode` is `staged`, pause after intake and confirm with the user before continuing to step 14.
14. RAG activation checkpoint: if `rag.mode` is `from_start`, explicitly raise and resolve the RAG question before continuing. This step is mandatory and blocks progression to step 15. Record the outcome in `docs/08-vector-db.md`.
15. Only then continue with work.

The agent must not skip this order unless the repository is materially broken and cannot be read.

## 3. Canonical Sources Of Truth

- Repository docs and code are the source of truth for goals, requirements, architecture, decisions, workflow, integrations, and vector DB configuration.
- `.ai-dev-template.config.json` is the source of truth for workflow policy, language, PR behavior, artifact persistence, and RAG workflow mode.
- GitHub Issues and GitHub Project are the source of truth for backlog, decomposition, status, and active work.
- Temporary session context is not a source of truth.

If meaningful state exists only in transient context, the task is not complete.

## 4. Environment Check Phase

The agent must perform environment checks:

- at project start;
- after initializing a repository from this template;
- before automation that depends on GitHub access.

The environment check must verify:

- `git` is installed;
- the working directory is a git repository;
- `git remote` is configured;
- `gh` CLI is installed;
- `gh auth status` succeeds;
- repository access is sufficient for issues and project maintenance;
- baseline project files exist.

The agent should use `scripts/check-environment.sh` as the default environment check when available.

The agent should use `scripts/check-github-permissions.sh` to validate token scopes when `gh` is available.

If a script cannot be executed or does not cover a required check, the agent must perform the missing checks manually.

If anything is missing, the agent must:

- report it explicitly;
- say what must be fixed;
- avoid silently continuing as if the environment were valid.

## 5. Mandatory Business Task Intake Phase

The agent must not jump from a raw business request straight into task decomposition or implementation.

The intake sequence is mandatory and must be handled one meaning block at a time:

1. Context and current problem
2. Target outcome and business value
3. Users, scenarios, and current process
4. Constraints, dependencies, and first-version boundaries
5. Success metrics and acceptance criteria
6. Risks, unknowns, and open questions
7. Implementation options

Rules for intake:

- Discuss one block at a time.
- After each user answer, briefly summarize the conclusion for that block.
- Only then move to the next block.
- Do not mix business goals, architecture, infrastructure, and implementation details in one step.
- Do not propose tech stack or vector DB during initial intake unless it is strictly required to understand the business problem.
- Follow the configured execution mode in `.ai-dev-template.config.json` when deciding whether to pause for human confirmation.

The intake result must make the following explicit:

- goal;
- expected result;
- boundaries;
- constraints;
- success criteria;
- assumptions;
- open questions.

Use `templates/business-task-intake.md` as the canonical intake structure.

## 6. Task Fixation Phase

Before starting implementation on any task, the agent must fill in `templates/task-start-checklist.md`. This checklist gates the human checkpoint check, PR classification, branch creation, and delivery mode statement. No implementation commit is allowed before the checklist is complete.

After intake is complete, the agent must:

- update `docs/01-product-vision.md` if needed;
- update `docs/02-business-requirements.md`;
- update `docs/03-scope-and-boundaries.md`;
- update `docs/00-project-overview.md` if needed;
- create an Epic;
- create linked delivery tasks.

The agent must not create execution tasks before the intake result is coherent enough to support Definition of Ready.

## 7. Decomposition Rules

Every task must:

- be atomic;
- produce one clear outcome;
- include completion criteria;
- include dependencies when they exist;
- avoid bundling unrelated goals.

New tasks start in `Backlog`.

## 8. GitHub Project Rules

- New tasks go to `Backlog`.
- A picked-up task moves to `In progress`.
- A finished task moves to `Closed`.
- The agent keeps the board current.
- The agent creates and maintains labels.

The human should not need to manually create or manage delivery cards.

## 9. Required Labels

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

Use `scripts/setup-labels.sh` to create and reconcile them.

## 10. Tech Stack Selection Rules

After intake and environment alignment, the agent must:

- identify the likely stack;
- justify each major choice;
- record alternatives considered;
- record risks;
- link official documentation and best practices;
- update `docs/04-tech-stack.md`.

The agent must not rely on undocumented "common practice" as the only justification for an architectural decision.

Language for docs, issues, PR text, agent comments, and commit messages must follow `.ai-dev-template.config.json`.

If repository language is Russian, the agent must write repository artifacts in clear Russian.

English terms are allowed only when at least one of the following is true:

- there is no accurate and commonly used Russian equivalent;
- the English term is more precise than the Russian translation;
- the English term is the established team or ecosystem term and is clearer in context.

The agent must not mix Russian text with avoidable English fragments.

The agent must prefer plain, reviewable wording over jargon.

Task descriptions, completion criteria, issue text, PR text, and commit messages must be understandable without translating mixed-language phrasing.

When an English technical term is used in Russian text, it must be intentional and necessary, not a placeholder for vague wording.

## 10A. External And Shared Library Rules

When working with an external library, framework, SDK, or internal shared library, the agent must not rely on memory, guesses, or "typical API" assumptions.

Required validation order:

1. check local documentation in the repository;
2. check existing usage examples in the codebase;
3. check the connected official documentation source;
4. if confirmation is still missing, mark the uncertainty explicitly and do not invent a solution.

Before changing code that depends on an external or shared library, the agent must verify:

- real signatures;
- types;
- method and option names;
- supported options;
- lifecycle rules and required patterns;
- version-specific limitations.

For each critical external dependency, the source of truth must be one of:

- a local docs file in the repository;
- an official documentation source available in the agent environment;
- an existing working example in the codebase.

The agent must not:

- invent API;
- use unconfirmed methods or parameters;
- rely on outdated patterns without checking the current library version.

If confirmed documentation is missing, the agent must:

- not make risky blind changes;
- leave a note about the missing source of truth;
- prefer the safest minimal change if one exists.

## 11. Best Practices Capture Rules

Before implementing with a chosen stack, the agent must:

1. identify key technologies;
2. identify official documentation;
3. extract critical best practices;
4. record them in `docs/04-tech-stack.md` and, if operational, in `docs/07-workflow.md`;
5. implement only after those practices are recorded.

## 11A. Code Navigation Rules

Before reading implementation files in depth or changing code, the agent must:

1. identify which application, package, service, or module is relevant to the task;
2. use `docs/05-architecture.md` as the project structure map;
3. localize the relevant repository area before reading files in depth;
4. search for context in the relevant area first;
5. avoid pulling unrelated repository areas into working context without a task-driven reason.

For monorepos and multi-application repositories, the agent must determine `where to work` before deciding `what to change`.

If `docs/05-architecture.md` does not contain enough structure information to localize the relevant area, the agent must update it before or alongside implementation.

## 12. Vector DB Rules

Vector DB is optional.

The agent must:

1. avoid bringing up vector DB during initial business intake unless strictly necessary;
2. consider vector DB only after intake and environment alignment are complete;
3. propose vector DB only if the documented use case justifies it;
4. never enable it without user approval;
5. if approved, ask which embedding provider or model to use;
6. record the decision in `docs/08-vector-db.md`;
7. tell the user which `.env` variables must be filled;
8. only then start `docker-compose.vector-db.yml`.

The compose file must be reused as provided by the template, not regenerated ad hoc.

RAG policy in `.ai-dev-template.config.json` defines whether the development workflow runs without RAG, may enable it later, or should prepare to use it from the start. User approval is still required before enabling vector DB infrastructure.

If `rag.mode` is `from_start`, the agent must not silently defer the RAG decision.

After intake and environment alignment are complete, but before active implementation starts, the agent must explicitly raise the RAG activation question and cover:

1. whether RAG is justified for the repository workflow;
2. whether vector DB should be activated now or deferred;
3. which embedding provider or model would be used if activated;
4. which `.env` values would be required.

The agent must then record the outcome in `docs/08-vector-db.md`, even when the decision is to defer activation.

## 12A. Workflow Configuration Rules

The agent must follow `.ai-dev-template.config.json`.

The agent must:

1. treat execution mode as binding workflow policy;
2. stop for explicit approval at configured human checkpoints;
3. treat PR flow as task-scoped when pull requests are enabled;
4. classify each task as PR-required or not before implementation starts;
5. state the delivery mode for the task before the first implementation commit;
6. follow PR, review, and merge policy for each task that requires a PR;
7. skip PR-specific steps when pull requests are disabled;
8. keep canonical docs and `AGENTS.md` in the repository as mandatory sources of truth;
9. avoid committing temporary work artifacts when `persist_temporary_workfiles_to_repo` is `false`.

Human checkpoints are categories of high-risk changes that require human approval even when the repository runs in `autonomous` or `hybrid` mode.

If `pull_requests.enabled` is `true` and the task is significant under repository policy, the agent must not commit or push implementation work directly to `main`.

For such tasks, the required path is:

1. classify the task as PR-required;
2. create or switch to a task branch;
3. make the branch ready for PR creation;
4. open a draft PR if policy requires it before the broader review and merge cycle;
5. continue implementation within that task branch and PR scope.

If the agent determines that a task does not require a PR, it must say so explicitly before the first implementation commit and justify that decision against repository policy.

If a task uses PR flow, the agent must apply the configured review and merge policy as follows:

- if `pull_requests.review.required` is `true`, do not treat the task as merge-ready before review requirements are satisfied;
- if `pull_requests.review.reviewers` is `human`, require human review and do not treat agent self-review as sufficient;
- if `pull_requests.review.reviewers` is `ai`, perform agent review as the required review path and record the result in the PR as a review summary or review comment;
- if `pull_requests.review.reviewers` is `both`, require both the agent review step and human review, and record the agent review result in the PR as a review summary or review comment;
- if `pull_requests.review.agent_must_read_comments` is `true`, read PR comments and review summaries before concluding review handling;
- if `pull_requests.review.agent_must_reply_to_comments` is `true`, reply where repository workflow expects a direct answer;
- if `pull_requests.review.agent_must_apply_accepted_feedback` is `true`, apply accepted review feedback before considering the PR ready;
- if `pull_requests.merge.squash_commits` is `true`, treat task commits as intended to be squashed before merge;
- if `pull_requests.merge.integration_method` is `merge`, preserve branch integration through a merge commit;
- if `pull_requests.merge.integration_method` is `rebase`, preserve branch integration through rebase;
- if `pull_requests.merge.require_green_checks` is `true`, do not treat the PR as merge-ready while required checks are failing or missing;
- if `pull_requests.merge.min_approvals` is greater than zero, do not treat the PR as merge-ready before that approval threshold is met;
- if `pull_requests.merge.allow_agent_self_merge` is `false`, the agent must not merge the PR itself;
- if `pull_requests.merge.agent_configure_branch_protection` is `true`, the agent must configure branch protection on the main branch via the GitHub API before starting any implementation work. The required rules are: require pull requests before merging, set minimum approvals to match `pull_requests.merge.min_approvals`, and disable bypassing protection. This requires the token user to have admin access to the repository.

If `pull_requests.creation_mode` is `manual_per_task`, the agent must not decide silently. It must ask for or reference an explicit human decision before treating the task as PR-free.

## 13. Documentation Rules

- Any significant decision must be persisted in `docs/`.
- Requirement changes must update `docs/02-business-requirements.md`.
- Architecture changes must update `docs/05-architecture.md` and `docs/06-decision-log.md`.
- Stack changes must update `docs/04-tech-stack.md`.
- Workflow changes must update `docs/07-workflow.md`.
- Workflow policy changes must update `.ai-dev-template.config.json` and `docs/11-workflow-configuration.md` when the meaning changes.

## 14. Consistency Rules

- Do not create parallel sources of truth.
- Do not change workflow casually.
- If a new request conflicts with documentation, update the docs or log the assumption explicitly.
- Do not rely on transient context as durable project memory.

## 15. Definition Of Ready

A task is ready only when the following are clear:

- goal;
- input data;
- boundaries;
- dependencies;
- completion criteria;
- expected outcome.

## 16. Definition Of Done

A task is done only when:

- the required result exists;
- documentation is updated;
- issue state is updated;
- GitHub Project status is updated;
- important decisions are recorded;
- new risks or limitations are recorded;
- a dedicated git commit is created for that task.

If pull requests are enabled in `.ai-dev-template.config.json`, task completion also requires compliance with the configured PR, review, and merge policy.

If no project-specific commit standard exists, use Conventional Commits and include the issue reference in the header or body. The commit message language must still follow `.ai-dev-template.config.json`.

## 17. Task Finalization Order

After each completed task, the agent must follow this order:

1. Persist the result in canonical sources.
2. Update docs.
3. Update the related issue.
4. Update the GitHub Project card.
5. Update labels or status if needed.
6. Create a dedicated commit for the task.
7. Ensure no significant state exists only in session context.
8. Only then reset or clear working context.

## 18. Explicit Prohibitions

The agent must not:

- implement before business task intake is complete;
- enable vector DB without user consent;
- ignore configured human checkpoints;
- apply a PR or merge workflow that conflicts with `.ai-dev-template.config.json`;
- create a second source of truth for tasks;
- treat session memory as persistent storage;
- add GitHub Copilot instructions to this repository;
- hide environment problems from the user.
