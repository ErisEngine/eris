# FAQ

**Do I need an OpenAI account?**
No. ERIS uses the OpenAI protocol, not OpenAI's service. Your ERIS key is the only key you need.

**Which clients work?**
Any OpenAI-compatible client that lets you set the base URL, including the official OpenAI SDKs for Python and JavaScript. See [`examples/`](../examples).

**How do I get an account?**
Public sign-up is closed for now; accounts are created by ERIS Labs.

**Why is the same model listed by two sellers?**
Sellers can list the same model id. Pin one with `seller/model`, or send the bare id and ERIS routes between the verified ones. See [Routing](routing.md).

**What if a seller fails halfway through my request?**
Before a reply has started, ERIS moves on to the next seller at no cost. If a stream breaks after it started, you are charged only for what was delivered.

**Why does a charge say est.?**
The seller did not report token usage, so ERIS estimated it from the text.

**Can I withdraw my buying balance?**
Not from the Dashboard: a buying balance pays for requests. Only seller earnings can be withdrawn. Contact [Support](https://erislabs.org/support) if something went wrong with a deposit.

**Does ERIS keep my prompts?**
No. ERIS records metadata (time, model, seller, tokens, price, status), not content. The seller that answers does receive the content.

**Is the ERIS source code open?**
No. This repository holds ERIS's public documentation and client examples; the exchange is operated by ERIS Labs at [erislabs.org](https://erislabs.org).
