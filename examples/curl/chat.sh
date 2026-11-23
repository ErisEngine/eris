#!/usr/bin/env bash
# One chat completion. -i prints the x-eris-* headers: who served it, how it was routed, what it cost.
set -euo pipefail
: "${ERIS_API_KEY:?set ERIS_API_KEY to your eris_sk_ key}"
BASE="${ERIS_BASE_URL:-https://erislabs.org/api/v1}"
MODEL="${ERIS_MODEL:-eris-starter/openai-fast}"

curl -sS -i "$BASE/chat/completions" \
  -H "Authorization: Bearer $ERIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":\"Say hello in five words.\"}],\"max_tokens\":40}"
