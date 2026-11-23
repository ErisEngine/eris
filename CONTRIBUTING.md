# Contributing

This repository holds ERIS's public documentation and client examples. Corrections and improvements to both are welcome.

## What fits here

- **Documentation fixes:** something in [`docs/`](docs) that is unclear, out of date, or does not match how ERIS behaves.
- **Examples:** a fix to an existing example, or a new one that shows a real use of the API in a few dozen lines.

The exchange's own source code is not in this repository. For account, deposit, payment or withdrawal problems, open a ticket in [Support](https://erislabs.org/support). For security issues, follow [SECURITY.md](SECURITY.md).

## Before you open a pull request

- **Accuracy over polish.** Every statement must describe what ERIS does today. If you are not sure, say so in the pull request and link what you observed.
- **Examples must run.** Read the key from `ERIS_API_KEY` and the base URL from `ERIS_BASE_URL` (default `https://erislabs.org/api/v1`). Never commit a key, a wallet address of your own, or a recorded response that contains one.
- **Keep it plain.** Short sentences, no marketing language, no unverifiable numbers.
- Run the same checks as CI:

```bash
bash -n examples/curl/*.sh
python -m py_compile examples/python/*.py
cd examples/typescript && npm install && npm run check
```

## Commits

One topic per pull request. Describe what changed and why in the first line, in the imperative ("Clarify how holds are sized"). Add an entry to [CHANGELOG.md](CHANGELOG.md) when the change affects readers.

By contributing you agree that your contribution is licensed under this repository's [MIT license](LICENSE).
