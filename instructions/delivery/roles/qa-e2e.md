# Delivery QA-E2E Role

## Mission

Prepare or implement test assets that belong to contour-owned implementation tasks without replacing the dedicated `e2e` task type.

## Read

- `docs/analysis/user-scenarios.md`
- `docs/analysis/version-scope-and-acceptance.md`
- `docs/analysis/ui-specification.md` when test behavior depends on UI flows
- `docs/analysis/integration-contracts.md` when end-to-end behavior depends on API or event contracts
- `docs/analysis/cross-cutting-concerns.md` when validation depends on observability, security, or operational requirements
- `docs/delivery/contour-task-matrix.md`

## Do Not Read By Default

- unrelated implementation internals
- deploy instructions

## Produce

- test assets required for later e2e validation
- surfaced gaps in scenarios, observability, or expected behavior

## Blockers

Route the task to `system_analysis` or `design` if end-user flows or acceptance expectations are incomplete.
