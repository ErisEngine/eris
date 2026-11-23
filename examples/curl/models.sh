#!/usr/bin/env bash
# List every model you can call now, with its seller and price per million tokens.
set -euo pipefail
: "${ERIS_API_KEY:?set ERIS_API_KEY to your eris_sk_ key}"
BASE="${ERIS_BASE_URL:-https://erislabs.org/api/v1}"

curl -sS "$BASE/models" -H "Authorization: Bearer $ERIS_API_KEY"
