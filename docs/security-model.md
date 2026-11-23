# Security model

How ERIS protects accounts, prompts, sellers and money. To report a vulnerability, see [SECURITY.md](../SECURITY.md).

| Area | Protection |
|---|---|
| API keys | Shown once, stored only as SHA-256 hashes. Revoking a key stops it on the next request; every call checks it. |
| Accounts | Passwords hashed with scrypt. The web session is an HttpOnly cookie lasting up to 30 days. Requests that change anything are refused when they come from another site. |
| Prompts | ERIS does not store the text of prompts or completions. Request content goes only to the seller that serves it. |
| Sellers | Endpoint keys are encrypted with AES-256-GCM. Endpoints must be on public addresses, checked before every call. Buyers never see a seller's endpoint address or key; sellers never see who a buyer is. |
| Errors | Buyers get short, sanitized messages with a reference. A seller's raw error output, addresses and anything key-like never reach a buyer. |
| Impersonation | Independent sellers cannot use a house listing's name or one containing "ERIS". Unverified sellers are marked and excluded from bare-model routing. |
| Deposits | Credited only from a wallet the account proved it controls with a signed message, and only after finality, for the amount actually received, once per transfer. |
| Withdrawals | Need the account password, go only to the linked wallet, and wait 24 hours after a new wallet is linked. |
| Treasury | One pooled wallet; its signing key never leaves the ERIS server. Balances are reconciled against the chain every settlement run. |
| Support | Tickets that contain a recovery phrase, private key, API key or password are refused before they are stored. |

**ERIS staff will never ask for your password, private key, recovery phrase or API keys.**

What this does not cover: ERIS is custodial, and USDG is a third-party stablecoin. The risks are set out in **[Custody and risk](https://erislabs.org/disclosures)**.
