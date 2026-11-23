# Examples

Runnable clients for the ERIS API, using the official OpenAI SDKs. Each reads these environment variables:

| Variable | Purpose |
|---|---|
| `ERIS_API_KEY` | Your key, from the [Dashboard](https://erislabs.org/dashboard). Required. |
| `ERIS_MODEL` | Optional. Defaults to `eris-starter/openai-fast`, which is free. |
| `ERIS_BASE_URL` | Optional. Defaults to `https://erislabs.org/api/v1`. |

```bash
export ERIS_API_KEY=eris_sk_...
```

## cURL

| Script | Shows |
|---|---|
| [`curl/models.sh`](curl/models.sh) | The model list, with sellers and prices. |
| [`curl/chat.sh`](curl/chat.sh) | One completion, with the `x-eris-*` headers. |
| [`curl/stream.sh`](curl/stream.sh) | A streamed completion as server-sent events. |
| [`curl/route.sh`](curl/route.sh) | A bare model id routed across verified sellers by price. |

## Python

```bash
pip install -r python/requirements.txt
python python/chat.py      # one completion, and who served it
python python/stream.py    # streamed output
python python/errors.py    # ERIS errors through the SDK's exception types
```

## TypeScript

Node.js 22.6 or later.

```bash
cd typescript && npm install
npm run chat     # one completion, and who served it
npm run stream   # streamed output
```

CI ([`examples.yml`](../.github/workflows/examples.yml)) checks shell syntax, compiles the Python and type-checks the TypeScript on every change.
