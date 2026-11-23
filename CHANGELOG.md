# Changelog

What changed in ERIS that matters to buyers and sellers, newest first. Dates are UTC.

## 2026-11-23

### Added
- **erislabs.org.** ERIS moves to its own domain, with canonical links, a sitemap, and `www` redirecting to the apex.
- **Documentation** rewritten from the running service, with captured requests and responses, at [erislabs.org/docs](https://erislabs.org/docs).
- **Support Center.** Help topics and private support tickets at [erislabs.org/support](https://erislabs.org/support).
- **Exchange activity.** A live ticker on the Marketplace, an Activity page, and notices for new accounts, listings and completed calls, with anonymous labels only.
- **Dashboard totals.** Deposited, spent, earned and withdrawn amounts, and a seller's listings with their prices.
- **Terms of use, Privacy notice, and Custody and risk** pages.
- **Cinematic motion.** A first-visit intro, entrance and scroll reveals, and pointer response for the Neural Core; off with reduced motion.

### Changed
- **Bare model ids route only to verified sellers.** Unverified independent sellers are marked, and reached only by their full `seller/model` id.
- **Seller names** that copy a house listing's name or contain "ERIS" are refused.
- **Buyer-facing errors** are short and sanitized, with a reference for support; a seller's own credential or credit failure is no longer shown as the buyer's error.

### Mainnet
- **USDG on Robinhood Chain (4663)** is the payment token, at 1 USDG = $1. Deposits are credited after finality; withdrawals need the account password, go to the linked wallet, and wait 24 hours after a new wallet is linked.
- **House listings:** ERIS Starter (free) and a verified set of OpenRouter models whose prices follow OpenRouter's.
- Public sign-up is closed; accounts are created by ERIS Labs.

## 2026-11-22

### Added
- **ERIS:** an OpenAI-compatible inference exchange. Sellers register endpoints and list priced models; buyers call one API.
- **Routing** across sellers by price, latency or both, with failover between sellers.
- **Metering and billing** from each seller's reported usage, with holds, charges and refunds for failed requests.
- **Settlement on Robinhood Chain,** first validated end to end on the chain's testnet.
- **Reliability:** health checks, per-key rate limits and daily quotas, and idempotent paid requests.
