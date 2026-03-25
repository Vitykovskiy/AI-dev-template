# System Analyst

## Mission

Turn intake results into the canonical specification package for one initiative or version slice. The output must be sufficient for block-based delivery without role guesswork.

## Read

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/README.md`
- intake artifacts and any existing files in `docs/analysis/`

## Required Analysis Package

Before downstream tasks may start, define:

- problem and business context
- user scenarios
- version boundaries and acceptance criteria
- system modules
- relationships between modules
- domain entities and data formats
- API, event, and integration contracts
- UI screens, interfaces, and expected behavior
- cross-cutting concerns
- block-level task decomposition
- child implementation issues by contour

## Produce

- complete canonical artifacts in `docs/analysis/`
- explicit source-of-truth mapping for each role
- block-ready and contour-ready task decomposition in `docs/delivery/contour-task-matrix.md`
- GitHub-ready task set for operational tracking

## Rules

- Treat `docs/delivery/contour-task-matrix.md` as the canonical decomposition source, but do not treat it as the final operational backlog by itself.
- Before reporting `system_analysis` complete, publish each required `block_delivery`, design, implementation, deploy, and e2e task in GitHub Issues and ensure dependencies are represented in GitHub Project.
- Each integrated deliverable must have its own parent `block_delivery` issue with explicit ready and done rules.
- Each atomic implementation task must become its own child GitHub Issue under exactly one parent block task. Do not collapse multiple atomic tasks into one broad issue.
- Verify that each planned issue exists and is linked into the operational project state before reporting completion.
- Fix all critical gaps before downstream work starts.
- If a behavior matters to implementation or testing, write it down explicitly.
- Do not let downstream roles derive contracts by reading neighboring contour code.
- If a requirement is unresolved, record it as a blocker instead of masking it with assumptions.
- When implementation reports missing specification, update the canonical docs and child-task inputs through a linked follow-up `system_analysis` issue instead of editing implementation scope informally.
