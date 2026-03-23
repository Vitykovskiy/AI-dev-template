# Phase 1 — Setup

You are in phase 1. Complete the following steps in order.

## 1. Read Configuration

Read `.ai-dev-template.config.json`. Record the values of all settings.

## 2. Check Environment

Verify that the following are available and working:
- git — installed and current directory is a repository
- gh — installed and authenticated (`gh auth status`)
- repository access on GitHub (push, issues, projects)

If anything is missing — report exactly what is wrong and what needs to be fixed. Do not continue until the problem is resolved.

## 3. Bootstrap GitHub Labels

Run `scripts/bootstrap-github-labels.sh` to create the required labels in the repository. The script is safe to re-run — existing labels are skipped.

If the script was already run by the human during repository setup — verify the labels exist and skip this step.

## 4. Bootstrap GitHub Project

Check whether a GitHub Project board is already linked to this repository:

```
gh project list --owner <owner>
```

If a project linked to this repository already exists — skip creation.

If no project exists — create one and link it to the repository:

```
gh project create --owner <owner> --title "<repository name>" --format json
gh project link <project-number> --owner <owner> --repo <owner>/<repo>
```

After creation, set the correct status options on the project's `Status` field so they match the delivery workflow:

- `Backlog`
- `In Progress`
- `Done`

Use `gh project field-list <project-number> --owner <owner>` to inspect existing fields before making changes.

The `project` scope is required for this step. If the token does not have it — stop and report the missing scope.

## 5. Adapt Delivery Instructions

Read `instructions/phase-3-delivery.md`.

Edit it to match the project configuration:
- Remove sections and instructions that do not apply given the current config settings.
- Replace generic descriptions with concrete values (e.g. execution mode, pull request policy).
- Do not use template placeholders — edit the file thoughtfully, as a human would.

## 6. Localize Templates

If `language.documentation` is not `en` — translate all files in `templates/` to the configured language. Translate all headings, labels, and body text.

If `language.issues` is not `en` — translate the following files to the configured language:

- `.github/ISSUE_TEMPLATE/bug.yml`
- `.github/ISSUE_TEMPLATE/feature.yml`
- `.github/ISSUE_TEMPLATE/task.yml`
- `.github/ISSUE_TEMPLATE/epic.yml`

Translate all user-visible text: `name`, `description`, field `label`, `description`, and `placeholder` values. Do not translate: YAML keys, `id` values, `labels` values (GitHub labels stay in English per config).

If `language.pull_requests` is not `en` — translate `.github/PULL_REQUEST_TEMPLATE.md` to the configured language. Translate all headings and body text.

If `language.documentation`, `language.issues`, and `language.pull_requests` are all `en` — skip this step.

## 7. Project Map

If `project_map.enabled = true` in the config:

Create `docs/project-map.md` — a file tree with a brief description of each folder's purpose and each key file. Goal: any agent starting a new session should understand the project structure without scanning the filesystem.

If `project_map.enabled = false` — skip this step.

## 8. Create Code Style Document

Create `docs/08-code-style.md` based on the tech stack chosen for this project.

Fill in the size limits table with concrete numbers appropriate for the stack. Examples:

- **Vue 3:** component ≤ 300 lines, composable ≤ 150 lines, store module ≤ 200 lines
- **React:** component ≤ 250 lines, custom hook ≤ 100 lines
- **Node.js / Express:** route handler ≤ 50 lines, service function ≤ 80 lines, file ≤ 400 lines
- **Go:** function ≤ 60 lines, file ≤ 500 lines
- **Python:** function ≤ 50 lines, class ≤ 300 lines, module ≤ 500 lines

Leave the Naming, Accepted Patterns, Forbidden Patterns, and Notes sections as stubs — they will be filled in as the project evolves. Do not invent conventions that have not been established yet.

## 9. Complete Phase

Delete this file: `instructions/phase-1-setup.md`

Commit and push the changes (`.ai-dev-template.config.json`, adapted `phase-3-delivery.md`, deleted `phase-1-setup.md`, and `docs/project-map.md` if created) directly to `main` following the commit rules from the project config. Phase 1 is repository initialization — it always commits and pushes directly to `main` regardless of the configured PR policy. This must happen before phase 3 configures branch protection, which would block direct pushes to `main`.

Tell the user that setup is complete and requirements gathering will begin in the next session.
