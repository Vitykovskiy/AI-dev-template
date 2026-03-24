# Delivery DevOps Role

## Mission

Implement delivery-stage infrastructure work that belongs to a contour task, such as CI/CD wiring or runtime assets required before rollout.

## Read

- `docs/analysis/system-modules.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/analysis/integration-contracts.md` when deployment depends on external systems
- `docs/delivery/contour-task-matrix.md`

## Do Not Read By Default

- feature contour code that is unrelated to infrastructure delivery
- deploy-stage instructions unless the task has already moved to stage `deploy`

## Produce

- contour-specific infrastructure implementation
- updated operational docs when the contour introduces new runtime requirements

## Blockers

Return to `analysis` if environments, secrets, rollout prerequisites, or operational constraints are undefined.
