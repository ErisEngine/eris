# Security policy

## Reporting a vulnerability

Please report security issues privately, never in a public issue or discussion.

**Use GitHub's private vulnerability reporting:** open the [Security tab](https://github.com/ErisEngine/eris/security) of this repository and choose **Report a vulnerability**. Only the maintainers can read the report.

Include what you found, where (a URL or endpoint), how to reproduce it, and what an attacker could do with it. A minimal proof of concept is welcome; please do not access other people's accounts or data, move funds, or degrade the service to demonstrate it.

## Scope

| In scope | Out of scope |
|---|---|
| erislabs.org and its API (`/api/v1`) | Third-party services ERIS relies on (report those to their owners) |
| Account, key, wallet-link, deposit and withdrawal flows | Seller endpoints run by independent sellers |
| The documentation and examples in this repository | Findings that need a compromised device or browser |
| | Volumetric denial of service and rate-limit exhaustion |

## Please do not

- Send funds to, or attempt transactions against, the ERIS treasury to test it.
- Use automated scanners at a rate that affects other users.
- Share a vulnerability publicly before it has been fixed.

## Never share secrets

ERIS staff will never ask for your password, private key, recovery phrase or API keys. If a report would require one, describe it instead. If a key of yours may have leaked, revoke it on the [Dashboard](https://erislabs.org/dashboard): it stops working on the next request.

How ERIS protects accounts, prompts and funds is described in the [security model](docs/security-model.md).
