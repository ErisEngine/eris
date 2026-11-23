// A streamed chat completion through ERIS: print the answer as it arrives.
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: process.env.ERIS_BASE_URL ?? "https://erislabs.org/api/v1",
  apiKey: process.env.ERIS_API_KEY,
});

const stream = await client.chat.completions.create({
  model: process.env.ERIS_MODEL ?? "eris-starter/openai-fast",
  messages: [{ role: "user", content: "Count from one to five." }],
  max_tokens: 60,
  stream: true,
});
for await (const chunk of stream) {
  process.stdout.write(chunk.choices[0]?.delta?.content ?? "");
}
process.stdout.write("\n");
