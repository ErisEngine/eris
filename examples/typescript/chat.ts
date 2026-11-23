// One chat completion through ERIS with the official OpenAI SDK, and who served it.
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: process.env.ERIS_BASE_URL ?? "https://erislabs.org/api/v1",
  apiKey: process.env.ERIS_API_KEY,
});

const { data, response } = await client.chat.completions
  .create({
    model: process.env.ERIS_MODEL ?? "eris-starter/openai-fast",
    messages: [{ role: "user", content: "Say hello in five words." }],
    max_tokens: 40,
  })
  .withResponse();

console.log(data.choices[0]?.message?.content);

// ERIS reports who served the request and how it was routed in response headers.
const tokens = data.usage ? `${data.usage.prompt_tokens} + ${data.usage.completion_tokens} tokens` : "usage not reported";
console.log(`served by ${response.headers.get("x-eris-provider")} (${response.headers.get("x-eris-route")}), ${tokens}`);
