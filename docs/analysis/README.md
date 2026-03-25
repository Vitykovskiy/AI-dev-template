# Analysis Package

`docs/analysis/` is the canonical implementation-ready specification package.

Design, implementation, deploy, and e2e tasks must work from these artifacts instead of inferring behavior from neighboring contour code.

## Required Files

- `problem-context.md`
- `user-scenarios.md`
- `version-scope-and-acceptance.md`
- `system-modules.md`
- `domain-model.md`
- `integration-contracts.md`
- `ui-specification.md`
- `cross-cutting-concerns.md`

## Source Of Truth By Role

- business analyst: intake-facing product docs plus scenario context
- system analyst: all analysis files in this folder
- designer: `user-scenarios.md`, `ui-specification.md`, `version-scope-and-acceptance.md`, consumed contract details
- frontend: `user-scenarios.md`, `ui-specification.md`, consumed portions of `integration-contracts.md`, `version-scope-and-acceptance.md`
- backend: `system-modules.md`, `domain-model.md`, produced and consumed portions of `integration-contracts.md`, `cross-cutting-concerns.md`, `version-scope-and-acceptance.md`
- devops: `cross-cutting-concerns.md`, runtime-related module and integration details, rollout constraints
- qa-e2e: `user-scenarios.md`, `ui-specification.md`, `version-scope-and-acceptance.md`, deployed environment notes

## Rule

If any role cannot execute from the artifacts it owns, the initiative is not ready and must return to `system_analysis` or `design` through GitHub task routing.
