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
- `design` if the initiative changes user experience or reusable design assets
- contour-owned `implementation` tasks
- `deploy`
- `e2e`

## Completion Rule

The initiative is complete only after:

1. required child tasks are created and linked by dependencies;
2. implementation tasks are finished by contour;
3. deployment succeeds;
4. e2e validation passes.
