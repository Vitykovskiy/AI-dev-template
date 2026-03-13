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
3. Read `docs/00-project-overview.md`.
4. Read `docs/01-product-vision.md`.
5. Read `docs/02-business-requirements.md`.
6. Read `docs/04-tech-stack.md`.
7. Read `docs/05-architecture.md`.
8. Check current GitHub issues.
9. Check the GitHub Project board.
10. Only then continue with work.

The agent must not skip this order unless the repository is materially broken and cannot be read.

## 3. Canonical Sources Of Truth

- Repository docs and code are the source of truth for goals, requirements, architecture, decisions, workflow, integrations, and vector DB configuration.
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

## 11. Best Practices Capture Rules

Before implementing with a chosen stack, the agent must:

1. identify key technologies;
2. identify official documentation;
3. extract critical best practices;
4. record them in `docs/04-tech-stack.md` and, if operational, in `docs/07-workflow.md`;
5. implement only after those practices are recorded.

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

## 13. Documentation Rules

- Any significant decision must be persisted in `docs/`.
- Requirement changes must update `docs/02-business-requirements.md`.
- Architecture changes must update `docs/05-architecture.md` and `docs/06-decision-log.md`.
- Stack changes must update `docs/04-tech-stack.md`.
- Workflow changes must update `docs/07-workflow.md`.

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

If no project-specific commit standard exists, use Conventional Commits and include the issue reference in the header or body.

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
- create a second source of truth for tasks;
- treat session memory as persistent storage;
- add GitHub Copilot instructions to this repository;
- hide environment problems from the user.
