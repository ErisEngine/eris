# Architecture

ERIS is one web application in front of a ledger and a chain. This page describes how its parts fit together, at the level a client developer or seller needs. The service's source code is not published.

## The system

```mermaid
flowchart TB
    subgraph Clients
      SDK["Buyers' apps<br/>OpenAI SDKs, HTTP"]
      WEB["erislabs.org<br/>marketplace, playground, dashboard"]
    end

    subgraph ERIS["ERIS application"]
      API["OpenAI-compatible API<br/>/api/v1"]
      RT["Router<br/>candidates, ranking, failover"]
      BL["Billing<br/>holds, charges, 95/5 split"]
      HC["Health checks<br/>discovery every 5 minutes"]
      ST["Settlement run<br/>every minute"]
    end

    DB[("PostgreSQL<br/>accounts, listings, requests,<br/>balances and their journal")]

    subgraph Sellers
      S1["House endpoints<br/>ERIS Starter, OpenRouter"]
      S2["Independent sellers<br/>verified or unverified"]
    end

    CH["Robinhood Chain<br/>USDG"]

    SDK --> API
    WEB --> API
    API --> RT --> BL
    RT <--> S1
    RT <--> S2
    HC --> S1
    HC --> S2
    BL --> DB
    RT --> DB
    ST --> DB
    ST <--> CH
```

| Part | What it does |
|---|---|
| API | Authenticates keys, validates the request, enforces per-key limits. |
| Router | Finds the listings that may serve a model, ranks them, tries up to three, records every attempt. See [Routing](routing.md). |
| Billing | Holds the worst-case cost, charges the tokens used, credits the seller 95% and the platform 5%. See [Billing](billing.md). |
| Health checks | Re-reads each seller's `/models` and marks endpoints and models online or offline. |
| Settlement run | Credits finalized USDG deposits from linked wallets, sends queued withdrawals, and reconciles the treasury's on-chain balance with what accounts are owed. |
| Ledger | Every balance change is a journal entry, and balances must always equal their journal. |

## A request's lifecycle

```mermaid
sequenceDiagram
    autonumber
    participant C as Client
    participant A as ERIS API
    participant R as Router
    participant L as Ledger
    participant S as Seller endpoint
    C->>A: POST /api/v1/chat/completions (Bearer key)
    A->>A: Key, body, per-minute and per-day limits
    A->>R: model, route mode
    R->>L: Hold the worst-case cost
    loop up to 3 sellers, best first
        R->>S: Request (model rewritten to the seller's id)
        alt seller answers
            S-->>R: Completion with usage
        else seller fails (unreachable, 5xx, 429, its own credentials)
            R->>L: Record the attempt (no cost)
        end
    end
    R->>L: Record the request, charge tokens × price, release the rest
    R-->>C: Completion + x-eris-* headers
```

- Prompts and completions pass through; ERIS records metadata (time, model, seller, tokens, price, status), not content.
- A seller's own failure (its credentials, its credit, its rate limit) is never shown to the buyer as the buyer's error.
- After three failed calls or checks in a row, an endpoint is tried only after healthier sellers until it succeeds again.

## The settlement loop

```mermaid
flowchart LR
    D["Buyer sends USDG<br/>from the linked wallet"] --> F{"Finalized<br/>on chain?"}
    F -- "no" --> F
    F -- "yes" --> CR["Credit the amount received<br/>once per transfer"]
    CR --> BAL[("Buyer balance")]
    BAL -- "requests" --> EARN[("Seller earnings<br/>95% of each charge")]
    EARN -- "withdrawal request<br/>password, linked wallet" --> Q["Queue"]
    Q --> TX["Sign and send USDG<br/>ERIS pays the network fee"]
    TX --> W["Seller wallet"]
    REC["Reconcile: treasury on chain<br/>vs. total owed"] -.-> BAL
    REC -.-> EARN
```

## Interface

The site is a Next.js application. One WebGL scene, the Chromatic Neural Core (three.js through React Three Fiber), stays mounted across pages; routes move its camera instead of reloading it, and each completed request sends a light along one of its filaments. Motion uses GSAP and Lenis, waits for the first-visit intro, and is reduced to stillness when the system asks for reduced motion.
