# Workflow

## Lifecycle

The repository enforces a fixed 6-stage lifecycle:

1. `setup`
2. `intake`
3. `analysis`
4. `delivery`
5. `deploy`
6. `e2e-test`

The lifecycle is sequential. A later stage may not compensate for a missing earlier-stage artifact.

## Stage Ownership

| Stage | Primary executor | Main output |
| --- | --- | --- |
| `setup` | technical agent | initialized repository and workflow baseline |
| `intake` | business analyst | business context, scenarios, scope, acceptance expectations |
| `analysis` | system analyst | implementation-ready specification package |
| `delivery` | contour role (`frontend`, `backend`, `devops`, etc.) | contour implementation from approved specs |
| `deploy` | devops | deployed system in target environment |
| `e2e-test` | qa-e2e | end-to-end validation result |

## Mandatory Flow

1. Start every session with `AGENTS.md`.
2. Determine the current stage.
3. Determine the active role for the session.
4. Read only the instruction branch and canonical artifacts allowed for that stage and role.
5. Produce only the artifacts and decisions owned by that stage and role.

## Stage Gates

### 1. Setup

Goal:
prepare the repository, workflow, and baseline documentation.

Exit condition:
the repository is ready for intake and later role routing.

### 2. Intake

Goal:
capture the business problem, target outcome, users, scenarios, scope, constraints, and success expectations.

Rules:

- work one semantic block at a time;
- do not decompose into implementation tasks yet;
- do not design system internals yet.

Exit condition:
the initiative is understood well enough to start system analysis.

### 3. Analysis

Goal:
create the canonical implementation-ready package in `docs/analysis/`.

The minimum required package includes:

- problem context
- user scenarios
- version scope and acceptance
- system modules
- module relationships
- domain model and data formats
- API, event, and integration contracts
- UI specification
- cross-cutting concerns
- contour task decomposition

Exit condition:
delivery roles can execute from their own artifacts and contracts without inferring behavior from sibling contour code.

### 4. Delivery

Goal:
implement one contour at a time from approved analysis artifacts.

Rules:

- one task, one contour;
- one session, one delivery role;
- frontend uses frontend specs and contracts;
- backend uses backend specs and contracts;
- missing specification is a blocker, not a coding prompt.

Exit condition:
all contour tasks for the initiative are implemented and documented.

### 5. Deploy

Goal:
roll the delivered system into the target environment as a separate stage.

Exit condition:
deployment completes and the target environment is ready for integrated validation.

### 6. E2E Test

Goal:
validate the deployed system against canonical user scenarios and acceptance criteria.

Exit condition:
e2e validation passes. Only then may the initiative be considered complete.

## Return-To-Analysis Rule

Return the initiative to `analysis` when any later-stage role finds a material gap in:

- expected user behavior;
- UI states or interactions;
- domain rules;
- payload or data formats;
- API or event contracts;
- non-functional or cross-cutting requirements;
- acceptance criteria needed for implementation, rollout, or testing.

Do not close the gap with ad hoc code assumptions.

## GitHub Lifecycle

GitHub Issues and GitHub Project remain the operational system of record.

Recommended initiative flow:

1. create or update the initiative record during `intake`;
2. complete the analysis package during `analysis`;
3. create contour-specific implementation tasks after analysis;
4. execute deploy tasks after contour delivery;
5. execute e2e tasks after deployment;
6. close the initiative only after successful e2e validation.

## Decomposition Rules

- Tasks must be atomic and contour-specific.
- Each delivery task must have exactly one owning contour.
- Cross-contour work is split into linked tasks instead of one shared task.
- Deploy and e2e tasks are separate from implementation tasks.

## Documentation Update Rules

- Business problem or goals change: update `docs/01-product-vision.md` and `docs/02-business-requirements.md`.
- Scope or acceptance changes: update `docs/03-scope-and-boundaries.md` and `docs/analysis/version-scope-and-acceptance.md`.
- System design changes: update the relevant files in `docs/analysis/`.
- Repository structure or runtime placement changes: update `docs/05-architecture.md`.
- Lifecycle or role rules change: update `AGENTS.md`, `instructions/`, and this file together.
- Material decisions change: update `docs/06-decision-log.md`.

## Execution Mode And PR Policy

The repository still uses `.ai-dev-template.config.json` for execution mode, approvals, and PR/review policy.

Those settings control how a stage is executed. They do not change the required lifecycle order or the role boundaries defined in this document.
