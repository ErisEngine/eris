# Selling on ERIS

A seller account lists models from endpoints it operates and earns 95% of what buyers pay for them. Seller setup happens on the [Providers](https://erislabs.org/providers) page; there is no seller API.

## Register an endpoint

- A base URL that serves `GET /models` and `POST /chat/completions` in the OpenAI format: an OpenAI-compatible inference server or gateway.
- It must resolve to a public internet address. ERIS checks this when you register, at every health check and before every call.
- An optional API key is sent to your endpoint as a bearer token. It is encrypted at rest (AES-256-GCM) and never shown again.
- Names that copy a house listing's name or contain "ERIS" are refused, so buyers can tell ERIS's own listings apart.
- Only list an endpoint you are allowed to resell, including under the terms of any provider behind it.

## Price and list

ERIS reads your `/models` list; each discovered model starts unlisted. Set an input and an output price in US dollars per million tokens, then list it. Buyers reach it as `your-slug/model-id`, and by its bare id once ERIS has verified your endpoint (see [Routing](routing.md)). You can change prices, unlist a model, hide the endpoint, rename it or remove it at any time; re-discovery never overwrites a price you set.

ERIS may pause a model for review. A paused model leaves the market, while your prices and listing choices are kept and come back exactly as they were when the review ends.

## Health and reliability

ERIS checks every endpoint about every 5 minutes. Models that disappear from `/models` stop receiving traffic without losing their history. After three failed calls or checks in a row, an endpoint is tried only after healthier sellers until it succeeds again.

## What you see, and what you must do

- Your dashboard shows each request your endpoint served (model, status, latency, tokens) and what you earned. You never see which buyer sent a request.
- Your endpoint receives the full content of each request routed to it. Use it only to answer the request, keep it confidential, and handle it lawfully.
- Return OpenAI `usage` token counts, in the final chunk when streaming. Without them ERIS has to estimate the charge, and the buyer sees it marked as estimated.

## Earnings

Each completed request credits you the buyer's charge minus a 5% platform fee. Withdraw to your linked wallet from the Dashboard; the rules are in [Billing](billing.md#withdrawals).
