# Contour Task Template

## Summary

- Task type: `implementation`
- Owner contour: `<designer/frontend/backend/devops/qa-e2e>`
- Initiative: `<epic or parent issue>`
- Parent block task: `<block_delivery issue>`
- GitHub Issue: `<issue id or URL>`
- GitHub Project status: `<Inbox/Ready/In Progress/Blocked/Waiting for Testing/Testing/Waiting for Fix/In Review/Done>`

## Goal

`<what this contour task must deliver>`

## Canonical Inputs

- `<analysis artifact>`
- `<design artifact or upstream dependency>`

## Dependencies

- `<task or contract dependency>`

## Definition Of Ready

- `<all upstream tasks complete>`
- `<canonical inputs exist>`

## Definition Of Done

- `<criterion>`
- `<criterion>`

## Blocker Rule

If the task cannot be completed from the listed inputs, mark it `Blocked` and route it to `system_analysis` or `design` instead of inferring missing behavior from code.

## Tracking Rule

This template represents exactly one atomic contour-owned implementation task and must map to exactly one GitHub Issue under exactly one parent `block_delivery` issue.
