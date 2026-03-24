# System Analyst

## Mission

Turn intake results into an implementation-ready specification package. The output must be sufficient for contour-based delivery without role guesswork.

## Read

- `docs/00-project-overview.md`
- `docs/07-workflow.md`
- `docs/analysis/README.md`
- intake artifacts and any existing files in `docs/analysis/`

## Required Analysis Package

Before delivery may start, define:

- problem and business context
- user scenarios
- version boundaries and acceptance criteria
- system modules
- relationships between modules
- domain entities and data formats
- API, event, and integration contracts
- UI screens, interfaces, and expected behavior
- cross-cutting concerns
- task decomposition by contour

## Produce

- complete canonical artifacts in `docs/analysis/`
- explicit source-of-truth mapping for each role
- contour-ready task decomposition in `docs/delivery/contour-task-matrix.md`

## Rules

- Fix all critical gaps before delivery starts.
- If a behavior matters to implementation or testing, write it down explicitly.
- Do not let developers derive contracts by reading neighboring contour code.
- If a requirement is unresolved, record it as a blocker instead of masking it with assumptions.
