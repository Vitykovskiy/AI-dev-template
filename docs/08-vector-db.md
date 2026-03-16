# Vector DB

## Current Position

Default status: `Not enabled`

Vector DB is optional development infrastructure for the agent workflow and must not be activated automatically.

## When It Is Not Needed

Vector DB is usually unnecessary when:

- project knowledge is small and can be handled by repository search;
- the agent can work from repository files and direct context without retrieval;
- data freshness requirements do not justify indexing complexity;
- cost or operational overhead outweighs retrieval benefit.

## When It May Be Needed

Consider vector DB only after business task intake is complete and the development workflow use case is documented.

Potential use cases:

- semantic search across repository documentation and working materials;
- retrieval augmentation for large internal knowledge bases used during development;
- context reduction when direct prompt context becomes too expensive or too small.

## If Enabled, Record The Following

- Business use case:
- Data to index:
- Canonical source of truth:
- Embedding provider:
- Embedding model:
- Chunking strategy:
- Indexing and sync policy:
- Retrieval policy:
- Cost considerations:
- Risks:

## Supported Embedding Modes

- OpenAI
- Another hosted provider
- Local embedding model
- No embedding provider because vector DB is not used

## Required Configuration

Populate `.env` as applicable:

- `QDRANT_HOST`
- `QDRANT_PORT`
- `QDRANT_API_KEY`
- `EMBEDDING_PROVIDER`
- `OPENAI_API_KEY`
- `OPENAI_EMBEDDING_MODEL`
- `EMBEDDING_API_URL`
- `EMBEDDING_API_KEY`
- `EMBEDDING_MODEL`
- `LOCAL_EMBEDDING_ENDPOINT`
- `LOCAL_EMBEDDING_MODEL`

## Activation Rule

The agent may start `docker-compose.vector-db.yml` only after:

1. the user agrees to use vector DB;
2. the embedding provider or model is chosen;
3. the decision is documented here;
4. required `.env` values are filled.

If `rag.mode` is `off`, the agent must not propose vector DB for normal repository work.

If `rag.mode` is `on_demand`, the agent may propose it later when context size, token cost, or repository scale justifies retrieval.

If `rag.mode` is `from_start`, the repository should prepare RAG as part of the development workflow from the beginning, but user approval is still required before infrastructure is started.
