#!/usr/bin/env bash
# A bare model id routed across verified sellers by price. The x-eris-provider header says which seller served it.
# If only unverified sellers list the model, the 404 names them so you can pin one as seller/model.
# Usage: ERIS_MODEL=mistralai/mistral-nemo ./route.sh
set -euo pipefail
: "${ERIS_API_KEY:?set ERIS_API_KEY to your eris_sk_ key}"
: "${ERIS_MODEL:?set ERIS_MODEL to a bare model id, such as mistralai/mistral-nemo}"
BASE="${ERIS_BASE_URL:-https://erislabs.org/api/v1}"

curl -sS -i "$BASE/chat/completions" \
  -H "Authorization: Bearer $ERIS_API_KEY" \
  -H "Content-Type: application/json" \
  -H "x-eris-route: price" \
  -d "{\"model\":\"$ERIS_MODEL\",\"messages\":[{\"role\":\"user\",\"content\":\"Hi\"}],\"max_tokens\":16}" \
  | grep -iE '^(HTTP/|x-eris-)|"error"|"content"'
