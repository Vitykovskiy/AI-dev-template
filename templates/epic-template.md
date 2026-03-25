# Epic Template

## Summary

- Workflow mode: `issue_driven`
- Task type: `initiative`
- Owner contour: `<business-analyst/system-analyst>`
- Project status: `Inbox`

## Goal

Describe the initiative outcome.

## Business Value

Why this initiative matters.

## Required Task Chain

- `business_analysis`
- `system_analysis`
- one or more `block_delivery` tasks
- `design` if the initiative changes user experience or reusable design assets
- contour-owned child `implementation` tasks under each `block_delivery`
- `deploy`
- `e2e`

## Completion Rule

The initiative is complete only after:

1. required child tasks are created and linked by dependencies;
2. each required `block_delivery` task reaches `Done` after integrated validation;
3. child implementation tasks are finished by contour;
4. deployment succeeds when required;
5. e2e validation passes.
