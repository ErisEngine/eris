#!/usr/bin/env bash
# A streamed completion: server-sent events, ending with a usage chunk and [DONE].
set -euo pipefail
: "${ERIS_API_KEY:?set ERIS_API_KEY to your eris_sk_ key}"
BASE="${ERIS_BASE_URL:-https://erislabs.org/api/v1}"
MODEL="${ERIS_MODEL:-eris-starter/openai-fast}"

curl -sS -N "$BASE/chat/completions" \
  -H "Authorization: Bearer $ERIS_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"stream\":true,\"messages\":[{\"role\":\"user\",\"content\":\"Count from one to five.\"}],\"max_tokens\":60}"
