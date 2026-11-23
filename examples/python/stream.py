"""A streamed chat completion through ERIS: print the answer as it arrives."""
import os

from openai import OpenAI

client = OpenAI(
    base_url=os.environ.get("ERIS_BASE_URL", "https://erislabs.org/api/v1"),
    api_key=os.environ["ERIS_API_KEY"],
)

stream = client.chat.completions.create(
    model=os.environ.get("ERIS_MODEL", "eris-starter/openai-fast"),
    messages=[{"role": "user", "content": "Count from one to five."}],
    max_tokens=60,
    stream=True,
)
for chunk in stream:
    if chunk.choices and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
print()
