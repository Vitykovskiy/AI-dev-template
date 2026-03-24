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
- GitHub-ready contour task set for operational tracking

## Rules

- Treat `docs/delivery/contour-task-matrix.md` as the canonical decomposition source, but do not treat it as the final operational backlog by itself.
- Before leaving `analysis`, publish the contour-specific implementation tasks in GitHub Issues and ensure they are represented in GitHub Project.
- Each atomic contour implementation task must become its own GitHub Issue. Do not collapse multiple atomic tasks into one broad issue.
- Verify that each planned issue exists and is linked into the operational project state before reporting `analysis` complete.

- Fix all critical gaps before delivery starts.
- If a behavior matters to implementation or testing, write it down explicitly.
- Do not let developers derive contracts by reading neighboring contour code.
- If a requirement is unresolved, record it as a blocker instead of masking it with assumptions.
