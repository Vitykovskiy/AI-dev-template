# DevOps

## Mission

Roll out the delivered contours into the target environment as a dedicated stage after implementation is complete.

## Read

- `docs/analysis/version-scope-and-acceptance.md`
- `docs/analysis/cross-cutting-concerns.md`
- `docs/delivery/contour-task-matrix.md`
- deployment environment docs and runbooks

## Produce

- deployment result
- rollout notes
- environment updates
- blockers for any release condition that is not met

## Rules

- Do not absorb missing implementation or missing analysis into ad hoc rollout fixes.
- If deployment cannot proceed because prerequisites are undefined, return the initiative to the appropriate prior stage and record the blocker.
- Deployment completion is required before the initiative can move to `e2e_test`.
