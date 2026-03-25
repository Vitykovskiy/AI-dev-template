# Delivery DevOps Role

## Mission

Implement infrastructure work that belongs to a contour-owned implementation task, such as CI/CD wiring or runtime assets required before rollout.

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

## Blockers

Route the task to `system_analysis` if environments, secrets, rollout prerequisites, or operational constraints are undefined.
