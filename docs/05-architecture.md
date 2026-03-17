# Architecture

## System Context

Describe the system boundary, major actors, and key external systems.

## Project Structure Map

Use this file as the navigation map for the repository.

Record the main applications, packages, services, and layers before implementation starts.

This map should help a new session understand:

- which parts of the repository exist;
- what each part is responsible for;
- where frontend, backend, shared, data, and infrastructure code live;
- which entry points and boundaries matter;
- which area should be inspected first for a given task.

For monorepos, this section is mandatory.

| Area | Path | Responsibility | Notes |
| --- | --- | --- | --- |
| `<app/package/service>` | `<path>` | `<responsibility>` | `<notes>` |

## Components

| Component | Responsibility | Inputs | Outputs | Notes |
| --- | --- | --- | --- | --- |
| `<component>` | `<responsibility>` | `<input>` | `<output>` | `<notes>` |

## Responsibility Boundaries

- Frontend:
- Backend:
- Data layer:
- Infrastructure:
- External integrations:

## Data Flows

1. `<flow step 1>`
2. `<flow step 2>`
3. `<flow step 3>`

## Integrations

- GitHub
- External APIs: `<fill if applicable>`
- Internal systems: `<fill if applicable>`

## Technical Risks

- `<technical risk>`
- `<technical risk>`

## Update Rule

Before reading large parts of the repository or changing code, the agent should use this file to localize the relevant area first.

If implementation changes project structure, component responsibilities, data flow, or integration assumptions, update this file together with `docs/06-decision-log.md`.
