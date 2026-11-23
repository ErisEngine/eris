# API reference

The ERIS API speaks the OpenAI chat completions protocol. Base URL:

```
https://erislabs.org/api/v1
```

Responses on this page were captured from real calls to `eris-starter/openai-fast`, ERIS's free house model. A model's reply text will differ from these.

**Contents:** [Authentication](#authentication) · [Models](#models) · [Chat completions](#chat-completions) · [Streaming](#streaming) · [Response headers](#response-headers) · [Request headers](#request-headers) · [Limits](#limits) · [Errors](#errors)

## Authentication

Send an API key as a bearer token on every request. Keys are created on the [Dashboard](https://erislabs.org/dashboard), shown once, and stored by ERIS only as a SHA-256 hash.

```http
Authorization: Bearer eris_sk_...
```

A key belongs to a buyer account, and every call it makes is billed to that account. Use keys from servers and scripts only; never ship one in a web page or a mobile app.

```http
HTTP/1.1 401 Unauthorized

{
  "error": {
    "message": "Missing API key. Send `Authorization: Bearer eris_sk_...`. Create one in the Dashboard.",
    "type": "authentication_error"
  }
}
```

## Models

`GET /models` lists every model you can call right now, in the OpenAI list format. A model is listed when its seller has priced and published it and it was present at the seller's last health check.

```bash
curl https://erislabs.org/api/v1/models -H "Authorization: Bearer $ERIS_API_KEY"
```

```json
{
  "object": "list",
  "data": [
    {
      "id": "eris-starter/openai-fast",
      "object": "model",
      "created": 1795401127,
      "owned_by": "ovh",
      "eris": {
        "provider": "eris-starter",
        "seller": "ERIS Starter",
        "upstream_id": "openai-fast",
        "house": true,
        "verified": true,
        "context_length": null,
        "pricing": {
          "input_per_1m_eris": "0",
          "output_per_1m_eris": "0",
          "input_per_1m_usd": 0,
          "output_per_1m_usd": 0
        }
      }
    }
  ]
}
```

| Field | Meaning |
|---|---|
| `id` | What to send as `model`: `seller-slug/upstream-id`. |
| `eris.upstream_id` | The seller's own model id. Sent alone, it routes across every verified seller that lists it. |
| `eris.house`, `eris.verified` | Whether ERIS operates the listing, and whether the seller is verified. |
| `eris.pricing` | Price per million tokens. `*_usd` is the seller's price in US dollars; `*_eris` is the same price in USDG (the field name is historical). They are equal: 1 USDG = $1. |
| `eris.context_length` | As the seller reports it; `null` when it does not. |

## Chat completions

`POST /chat/completions` takes the OpenAI request body. ERIS checks `model`, `messages`, `max_tokens` (or `max_completion_tokens`) and its own `route` field, then forwards the rest to the seller unchanged, with `model` replaced by the seller's own id. The seller's response body comes back as it is, including any fields the seller adds.

```bash
curl https://erislabs.org/api/v1/chat/completions \
  -H "Authorization: Bearer $ERIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"eris-starter/openai-fast","messages":[{"role":"user","content":"Say hello in five words."}],"max_tokens":40}'
```

```http
HTTP/1.1 200 OK
content-type: application/json
x-eris-provider: eris-starter
x-eris-model: openai-fast
x-eris-route: pinned
x-eris-attempts: 1
x-eris-latency-ms: 2647
x-eris-price-input: 0
x-eris-price-output: 0
x-ratelimit-limit-requests: 60
x-ratelimit-remaining-requests: 59
x-eris-quota-remaining: 999

{
  "id": "pllns_a8ee0b1a2a82ae88fae0fe2601ef8c68",
  "object": "chat.completion",
  "created": 1795097363,
  "model": "gpt-oss-20b",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hey there, how's it going?",
        "reasoning": "We need to say hello in five words. Just answer concisely."
      },
      "finish_reason": "stop"
    }
  ],
  "usage": { "prompt_tokens": 317, "completion_tokens": 33, "total_tokens": 350 },
  "user_tier": "anonymous"
}
```

Parameters such as `temperature`, `tools` or `response_format` pass through, so whether they work depends on the seller's model.

## Streaming

Set `"stream": true` and ERIS passes the seller's server-sent events through unchanged. It asks the seller to put token usage in the final chunk (`stream_options.include_usage`) and retries once without that option if the seller rejects it.

```text
data: {"id":"chatcmpl-req_01M7X6JK7DGGGX7XX7KQMRJ8WZ","object":"chat.completion.chunk","model":"gpt-oss-20b","choices":[{"index":0,"delta":{"role":"assistant","content":""}}]}

data: {"id":"chatcmpl-req_01M7X6JK7DGGGX7XX7KQMRJ8WZ","object":"chat.completion.chunk","model":"gpt-oss-20b","choices":[{"index":0,"delta":{"role":"assistant","reasoning":"Need"}}]}

…

data: {"id":"chatcmpl-req_01M7X6JK7DGGGX7XX7KQMRJ8WZ","object":"chat.completion.chunk","model":"gpt-oss-20b","choices":[],"usage":{"prompt_tokens":317,"completion_tokens":25,"total_tokens":342}}

data: [DONE]
```

- Some models stream reasoning in a `reasoning` field before the answer in `content`.
- Streamed calls have no `x-eris-charge` header; the charge appears in Dashboard transactions as soon as the stream ends.
- If you close the stream early, or the seller stops mid-stream, you are charged for what was delivered: the seller's reported usage, or an estimate marked as such.

## Response headers

| Header | Meaning |
|---|---|
| `x-eris-provider` | Slug of the seller that answered. |
| `x-eris-model` | The seller's model id that was called. |
| `x-eris-route` | `pinned`, `balanced`, `price` or `latency`: how the seller was chosen. |
| `x-eris-attempts` | Sellers tried, including the one that answered. |
| `x-eris-latency-ms` | Time the seller took (not streamed calls). |
| `x-eris-price-input`, `x-eris-price-output` | The serving seller's listed price, US dollars per million tokens. |
| `x-eris-reserved` | USDG held while the request ran (paid listings). |
| `x-eris-charge` | USDG charged (paid listings, not streamed calls). |
| `x-ratelimit-limit-requests`, `x-ratelimit-remaining-requests` | The key's per-minute limit and what is left this minute. |
| `x-eris-quota-remaining` | Requests left today (UTC). |

## Request headers

| Header | Meaning |
|---|---|
| `x-eris-route` | Route mode, as an alternative to the `route` body field. See [Routing](routing.md). |
| `Idempotency-Key` | Any unique string up to 200 characters. A paid request repeated with the same key is refused with 409 instead of charged twice. |

## Limits

| Limit | Value |
|---|---|
| Requests per minute, per key | 60 by default, up to 600 |
| Requests per day (UTC), per key | 1,000 by default, up to 100,000 |
| Request body | 1 MB |
| Sellers tried per request | 3 |
| Time per request | Up to 2 minutes per seller, about 4½ minutes in total |

Set a key's limits on the Dashboard. A request over a limit is refused before any seller is contacted:

```http
HTTP/1.1 429 Too Many Requests
retry-after: 23
x-ratelimit-remaining-requests: 0

{"error":{"message":"Rate limit (requests per minute) exceeded: 60. Try again in 23s.","type":"rate_limit_error"}}
```

## Errors

Errors use the OpenAI envelope. Seller failures add a `code`, and the message carries a reference you can quote to [Support](https://erislabs.org/support).

| Status | `type` / `code` | When |
|---|---|---|
| 400 | `invalid_request_error` | The body is not JSON, `model` is missing, `messages` is empty, `max_tokens` is not a positive integer, or `route` is unknown. |
| 401 | `authentication_error` | Missing, unknown or revoked key. |
| 402 | `insufficient_balance` | The balance cannot cover the hold for this request. No seller was contacted. |
| 404 | `model_not_found` | No listed seller serves the model; for a bare id, no verified seller does, and the message names unverified sellers you can pin. |
| 404 | `upstream_error` / `model_unavailable` | The seller no longer serves the model. |
| 409 | `idempotency_conflict` | A request with this `Idempotency-Key` was already accepted. |
| 413 | `body_too_large` | The request body is over 1 MB. |
| 413 | `upstream_error` / `request_too_large` | Too long for the model. |
| 4xx | `upstream_error` / `upstream_rejected` | The seller rejected the request itself. |
| 429 | `rate_limit_error` | The key's per-minute or per-day limit. |
| 502 | `upstream_error` / `upstream_unreachable`, `upstream_unavailable`, `upstream_error` | Every seller tried failed. Nothing was charged. |
| 503 | `upstream_error` / `upstream_rate_limited`, `upstream_unavailable` | Busy or down at the source. See `Retry-After`. |
| 504 | `upstream_error` / `upstream_timeout` | The seller took too long. |

Captured validation errors, exactly as returned:

```json
{"error":{"message":"`model` is required","type":"invalid_request_error"}}
{"error":{"message":"`route` must be one of balanced, price, latency","type":"invalid_request_error"}}
{"error":{"message":"`max_tokens` must be a positive integer","type":"invalid_request_error"}}
{"error":{"message":"No listed provider serves model \"no-such-model\". Call GET /api/v1/models for the live list.","type":"model_not_found"}}
```

Error messages never include a seller's endpoint address, keys or raw error output.
