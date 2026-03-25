# Delivery QA-E2E Role

## Mission

Prepare or implement test assets that belong to contour-owned child implementation tasks without replacing the dedicated block-level validation owned by `qa-e2e`.

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
- status evidence that lets the parent block task move toward integrated testing

## Blockers

Do not substitute local test assumptions for missing canonical expectations.
If end-user flows or acceptance expectations are incomplete, mark the implementation issue `Blocked` and route it to a linked `system_analysis` or `design` follow-up issue.
