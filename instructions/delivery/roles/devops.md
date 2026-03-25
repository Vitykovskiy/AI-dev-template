# Delivery DevOps Role

## Mission

Implement infrastructure work that belongs to one contour-owned child implementation task inside a parent block deliverable, such as CI/CD wiring or runtime assets required before rollout.

## Read

- `docs/analysis/system-modules.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/analysis/integration-contracts.md` when deployment depends on external systems
- `docs/delivery/contour-task-matrix.md`

## Do Not Read By Default

- feature contour code that is unrelated to infrastructure delivery
- deploy instructions unless the task itself is a separate `deploy` task

## Produce

- contour-specific infrastructure implementation
- updated operational docs when the contour introduces new runtime requirements
- status evidence that lets the parent block task move toward integrated testing

## Blockers

Do not patch around missing operational requirements by inventing environment assumptions.
If environments, secrets, rollout prerequisites, or operational constraints are undefined, mark the implementation issue `Blocked` and route it to a linked `system_analysis` follow-up issue.
