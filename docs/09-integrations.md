# Integrations

## GitHub Project

- URL: `<paste GitHub Project URL here>`
- Board type: `Kanban`
- Required statuses present: `yes/no`
- Required fields present: `Status`, `Priority`, `Area`

## Environment Variables

| Variable | Required | Purpose | Status |
| --- | --- | --- | --- |
| `QDRANT_HOST` | Optional | Vector DB host | Not set |
| `QDRANT_PORT` | Optional | Vector DB port | Not set |
| `QDRANT_API_KEY` | Optional | Qdrant API protection | Not set |
| `EMBEDDING_PROVIDER` | Optional | Embedding mode selector | Not set |
| `OPENAI_API_KEY` | Optional | OpenAI embeddings | Not set |
| `OPENAI_EMBEDDING_MODEL` | Optional | OpenAI embedding model | Not set |
| `EMBEDDING_API_URL` | Optional | Hosted embedding endpoint | Not set |
| `EMBEDDING_API_KEY` | Optional | Hosted embedding auth | Not set |
| `EMBEDDING_MODEL` | Optional | Hosted embedding model id | Not set |
| `LOCAL_EMBEDDING_ENDPOINT` | Optional | Local embedding endpoint | Not set |
| `LOCAL_EMBEDDING_MODEL` | Optional | Local model name | Not set |

## Tokens And Secrets

| Secret | Where It Lives | Purpose | Status |
| --- | --- | --- | --- |
| `gh` auth token | GitHub CLI auth store | Issues and Project automation | Unknown |
| Embedding provider key | `.env` or external secret manager | Optional vector DB embeddings | Not set |

## GitHub Token Scope Baseline

Required scopes:

- `repo`
- `project`

Recommended scopes:

- `read:org`
- `workflow`

Validation note:

- token scopes are necessary but not sufficient;
- repository membership, project write access, and branch protection rules must still be validated separately;
- use `bash scripts/check-github-permissions.sh` to inspect the current `gh` token baseline.

## Integration Status

- GitHub repository access: `Unknown`
- GitHub Project access: `Unknown`
- Vector DB: `Disabled by default`

## Setup Notes

- Update this file as integrations are connected.
- Do not store production secrets in committed files.
- If the project uses a separate secret manager, document the reference location here.
