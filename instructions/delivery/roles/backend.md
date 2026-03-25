# Backend Role

## Mission

Implement the backend child task for its parent block deliverable from the approved analysis package and published contracts.

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
- status evidence that lets the parent block task move toward integrated testing

## Blockers

Do not infer missing behavior from frontend code, sibling issues, or ad hoc discussion.
If domain rules, payload formats, integration semantics, or non-functional requirements are unclear, mark the implementation issue `Blocked` and route it to a linked `system_analysis` follow-up issue.
