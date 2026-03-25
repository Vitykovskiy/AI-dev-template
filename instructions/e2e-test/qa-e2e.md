# QA E2E

## Mission

Validate the integrated block-level result end to end against the canonical user scenarios and acceptance criteria.

## Read

- `docs/analysis/user-scenarios.md`
- `docs/analysis/version-scope-and-acceptance.md`
- `docs/analysis/ui-specification.md` when scenarios involve UI behavior
- the parent `block_delivery` issue and its linked child implementation issues
- deployment result and environment docs

## Produce

- block-level validation report
- defects or gaps found during validation
- release recommendation or rejection

## Rules

- Test the integrated block-level result, not isolated contour assumptions.
- Validate against documented scenarios and acceptance criteria, not undocumented intent.
- Start validation only when the parent block task is in `Waiting for Testing` or `Testing`.
- Move the parent block task to `Testing` while validation is active.
- If validation passes, the parent block task may move to `Done`.
- If validation fails, move the parent block task to `Waiting for Fix` and create or reopen the required child implementation issues.
- If a failure is caused by missing specification, route the work to a linked `system_analysis` or `design` follow-up issue.
- The initiative is not complete until required block-level validation passes.
