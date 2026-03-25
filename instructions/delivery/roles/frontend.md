# Frontend Role

## Mission

Implement the frontend contour from the approved analysis package, design inputs, and consumed contracts.

## Read

- `.ai-dev-template.config.json`
- `docs/analysis/user-scenarios.md`
- `docs/analysis/ui-specification.md`
- `docs/analysis/integration-contracts.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/analysis/version-scope-and-acceptance.md`
- `docs/delivery/contour-task-matrix.md`

Read backend code only when integrating with already-specified contracts, not to infer requirements.

## Do Not Read By Default

- backend implementation internals
- unrelated contour tasks
- deploy and e2e instructions

## Produce

- frontend implementation
- frontend-facing documentation updates
- surfaced blockers when the specification is incomplete

## Architecture Policy

- If `.ai-dev-template.config.json` sets `architecture.use_fsd` to `true`, organize frontend code around FSD layers and respect their boundaries.
- If `.ai-dev-template.config.json` sets `architecture.use_fsd` to `false`, do not impose FSD; follow the repository's documented frontend structure instead.

## Blockers

Route the task to `system_analysis` or `design` if UI states, contract semantics, validation rules, or acceptance behavior are unclear.
