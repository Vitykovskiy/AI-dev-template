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

## 3. Adapt Delivery Instructions

Read `instructions/phase-3-delivery.md`.

Edit it to match the project configuration:
- Remove sections and instructions that do not apply given the current config settings.
- Replace generic descriptions with concrete values (e.g. execution mode, pull request policy).
- Do not use template placeholders — edit the file thoughtfully, as a human would.

## 4. Localize Templates

If `language.documentation` is not `en` — translate all files in `templates/` to the configured language. Translate all headings, labels, and body text.

If `language.issues` is not `en` — translate the following files to the configured language:

- `.github/ISSUE_TEMPLATE/bug.yml`
- `.github/ISSUE_TEMPLATE/feature.yml`
- `.github/ISSUE_TEMPLATE/task.yml`
- `.github/ISSUE_TEMPLATE/epic.yml`

Translate all user-visible text: `name`, `description`, field `label`, `description`, and `placeholder` values. Do not translate: YAML keys, `id` values, `labels` values (GitHub labels stay in English per config).

If `language.pull_requests` is not `en` — translate `.github/PULL_REQUEST_TEMPLATE.md` to the configured language. Translate all headings and body text.

If `language.documentation`, `language.issues`, and `language.pull_requests` are all `en` — skip this step.

## 5. Project Map

If `project_map.enabled = true` in the config:

Create `docs/project-map.md` — a file tree with a brief description of each folder's purpose and each key file. Goal: any agent starting a new session should understand the project structure without scanning the filesystem.

If `project_map.enabled = false` — skip this step.

## 6. Complete Phase

Delete this file: `instructions/phase-1-setup.md`

Commit and push the changes (adapted `phase-3-delivery.md`, deleted `phase-1-setup.md`, and `docs/project-map.md` if created) directly to `main` following the commit rules from the project config. Phase 1 is repository initialization — it always commits and pushes directly to `main` regardless of the configured PR policy. This must happen before phase 3 configures branch protection, which would block direct pushes to `main`.

Tell the user that setup is complete and requirements gathering will begin in the next session.
