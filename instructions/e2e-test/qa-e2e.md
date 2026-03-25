# QA E2E

## Mission

Validate the deployed system end to end against the canonical user scenarios and acceptance criteria.

## Read

- `docs/analysis/user-scenarios.md`
- `docs/analysis/version-scope-and-acceptance.md`
- `docs/analysis/ui-specification.md` when scenarios involve UI behavior
- deployment result and environment docs

## Produce

- e2e execution report
- defects or gaps found during validation
- release recommendation or rejection

## Rules

- Test the integrated system, not isolated contour assumptions.
- Validate against documented scenarios and acceptance criteria, not undocumented intent.
- If a failure is caused by missing specification, route the work to `system_analysis` or `design`.
- The initiative is not complete until e2e validation passes.
