"""ERIS errors use the OpenAI envelope, so the SDK's exception types apply."""
import os

import openai
from openai import OpenAI

client = OpenAI(
    base_url=os.environ.get("ERIS_BASE_URL", "https://erislabs.org/api/v1"),
    api_key=os.environ["ERIS_API_KEY"],
)

try:
    client.chat.completions.create(model="no-such-model", messages=[{"role": "user", "content": "hi"}])
except openai.NotFoundError as e:  # 404 model_not_found
    print("not found:", e.message)
except openai.RateLimitError as e:  # 429: wait for Retry-After
    print("rate limited; retry after", e.response.headers.get("retry-after"), "s")
except openai.APIStatusError as e:  # 402 insufficient_balance, 5xx seller failures, ...
    print(e.status_code, e.message)
