# Backend Role

## Mission

Implement the backend contour from the approved analysis package and published contracts.

## Read

- `docs/analysis/system-modules.md`
- `docs/analysis/domain-model.md`
- `docs/analysis/integration-contracts.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/analysis/version-scope-and-acceptance.md`
- `docs/delivery/contour-task-matrix.md`

Read frontend code only when validating that implementation matches an existing contract, not to derive product behavior.

## Do Not Read By Default

- frontend implementation internals
- unrelated contour tasks
- deploy and e2e instructions

## Produce

- backend implementation
- backend-facing documentation updates
- explicit blockers where contracts or domain rules are incomplete

## Blockers

Route the task to `system_analysis` if domain rules, payload formats, integration semantics, or non-functional requirements are unclear.
