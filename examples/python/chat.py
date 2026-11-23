"""One chat completion through ERIS with the official OpenAI SDK, and who served it."""
import os

from openai import OpenAI

client = OpenAI(
    base_url=os.environ.get("ERIS_BASE_URL", "https://erislabs.org/api/v1"),
    api_key=os.environ["ERIS_API_KEY"],
)

raw = client.chat.completions.with_raw_response.create(
    model=os.environ.get("ERIS_MODEL", "eris-starter/openai-fast"),
    messages=[{"role": "user", "content": "Say hello in five words."}],
    max_tokens=40,
)
resp = raw.parse()
print(resp.choices[0].message.content)

# ERIS reports who served the request and how it was routed in response headers.
usage = resp.usage
tokens = f"{usage.prompt_tokens} + {usage.completion_tokens} tokens" if usage else "usage not reported"
print(f"served by {raw.headers.get('x-eris-provider')} ({raw.headers.get('x-eris-route')}), {tokens}")
