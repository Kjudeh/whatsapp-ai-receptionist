# Deploy and Host WhatsApp AI Receptionist on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/whatsapp-ai-receptionist)

Deploy a **complete, working AI receptionist** for your business WhatsApp number in one click — not raw API plumbing. A customer messages your number; an AI agent (Claude or GPT, using **your own API key**) answers instantly with your business context, hands off to a human on request, and sends an office-hours auto-reply when you're closed.

Built on battle-tested open source: [Evolution API](https://github.com/EvolutionAPI/evolution-api) (9.3k★) for the WhatsApp connection and [n8n](https://github.com/n8n-io/n8n) (201k★) for the agent workflow — preloaded and wired together, so it works the moment you scan a QR code.

**Who it's for:** clinics, salons, restaurants, real-estate agents, e-commerce stores, agencies — any business that gets WhatsApp messages faster than a human can answer them, and any builder who wants a self-hosted WhatsApp + AI foundation to customize.

## About Hosting WhatsApp AI Receptionist

This template deploys four services, pre-wired over Railway's private network:

| Service | Version | Role |
|---|---|---|
| **Evolution API** | `v2.3.7` (pinned by tag + sha256 digest) | WhatsApp gateway — QR pairing, send/receive, manager UI |
| **n8n** | `2.35.3` (pinned by tag + sha256 digest) | Preloaded "WhatsApp AI Receptionist" workflow (auto-imported and activated) |
| **PostgreSQL** | Railway managed | Sessions, messages, contacts + n8n data (separate schema) |
| **Redis** | Railway managed | Evolution cache — fast instance/session lookups |

Postgres, Redis, and the Evolution↔n8n webhook are never exposed publicly. WhatsApp auth lives in Postgres **and** a volume mounted at `/evolution/instances` — **it survives restarts and redeploys with no QR re-scan**. Versions are pinned by digest and bumped only through reviewed PRs, checked weekly against upstream; Evolution is deliberately kept on the v2.3.x line (v2.4.0+ requires a license activation).

**Setup (~5 minutes):**

1. Click **Deploy Now**, paste your **Anthropic (or OpenAI) API key**, your **business name**, and a short **system prompt** describing your business (services, prices, address, tone). Everything else is auto-generated.
2. Wait for the four services to go green, then open the Evolution API service's URL at `/manager` and log in with the `AUTHENTICATION_API_KEY` (under the Evolution service → Variables).
3. Create an instance (any name, e.g. `reception`), choose **Baileys**, and scan the QR code from your business phone: WhatsApp → Settings → Linked devices.
4. Send a WhatsApp message to that number from another phone. The AI answers in seconds. Done — it's live 24/7.
5. *(Optional)* Open the n8n service URL, create your owner account, and extend the receptionist workflow with any of n8n's 400+ integrations.
6. *(Optional)* Set `OFFICE_HOURS` (e.g. `09:00-18:00`) and `GENERIC_TIMEZONE` (e.g. `America/New_York`) on the n8n service for the after-hours auto-reply.

**Built-in behaviors:** instant AI answers with your business context · human handoff (customer types `human` — configurable via `HANDOFF_KEYWORD` — and the bot steps aside with a courtesy message) · office-hours auto-reply · groups and your own outgoing messages are ignored automatically.

## Common Use Cases

- **After-hours receptionist** — answer questions about hours, location, pricing, availability while you sleep
- **Lead qualification** — greet inbound leads instantly, collect intent, hand off hot ones to a human
- **Booking assistant** — extend the n8n workflow with Google Calendar or Cal.com nodes to take reservations
- **Order/FAQ support for e-commerce** — connect n8n to Sheets, Airtable, or your store's API for live answers
- **Foundation stack** — the same Evolution + n8n pairing powers Chatwoot, Typebot, Dify, and Flowise integrations; swap our workflow for anything

## Dependencies for WhatsApp AI Receptionist Hosting

- An **Anthropic or OpenAI API key** (the AI replies use your key directly — no markup, typically $1–3/mo with Claude Haiku)
- A **WhatsApp number** on a phone that can scan a QR code (a dedicated business number is strongly recommended)

### Deployment Dependencies

- [Template source + workflow code (GitHub)](https://github.com/Kjudeh/whatsapp-ai-receptionist)
- [Evolution API documentation](https://doc.evolution-api.com)
- [n8n documentation](https://docs.n8n.io)
- [Anthropic API keys](https://console.anthropic.com) · [OpenAI API keys](https://platform.openai.com)

### Implementation Details — FAQ & Security

**Does my WhatsApp session survive redeploys?** Yes. Session auth is stored in Postgres and on a persistent volume. Restart, redeploy, or upgrade — no QR re-scan.

**Which AI models can I use?** Default is Anthropic's Claude Haiku. Set `LLM_PROVIDER=openai` for GPT models, or `LLM_MODEL` to any model id (e.g. `claude-sonnet-4-6`). Your key, your costs.

**Does the bot remember conversation history?** Out of the box each message is answered independently (with your full business context). Multi-turn memory is a straightforward n8n extension — the workflow is yours to edit.

**Can I get banned? Is this official?** This uses Evolution API, an **unofficial** WhatsApp client built on Baileys (WhatsApp Web protocol). It is **not affiliated with, endorsed by, or supported by Meta/WhatsApp**. Accounts that spam or mass-message can be restricted or banned — use a dedicated business number, reply to inbound messages rather than broadcasting, and avoid cold outreach. For regulated or mission-critical workloads, use the official WhatsApp Business API instead.

**Can I edit the AI's behavior after deploying?** Yes — change `SYSTEM_PROMPT`, `OFFICE_HOURS`, `HANDOFF_KEYWORD`, etc. in the n8n service Variables, or edit the workflow visually in n8n. Note: redeploying the n8n service re-imports the stock workflow under its original ID — if you customize it, **Save As a copy first**.

**Security:** all credentials live in Railway Variables — nothing sensitive is baked into images. The Evolution API key and n8n encryption key are auto-generated per deploy; treat the Evolution key like a password. Create a strong n8n owner password on first visit. Volume-backed services run a single replica (don't scale Evolution horizontally; sessions are stateful).

## Why Deploy WhatsApp AI Receptionist on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying WhatsApp AI Receptionist on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.

Compared to the SaaS route, there are **no platform fees**: a typical always-on deployment runs ~$10–15/mo flat, usage-based. The same 3,000 conversations/mo that cost $75–250+ on Twilio WhatsApp + a bot SaaS (per-message fees + Meta conversation fees + $29–99 seat) cost you Railway compute plus a few dollars of LLM tokens — and your data stays in your own database, with the full n8n editor to customize the agent.

---

*Built by [Bubbles Studio](https://bubbles.studio) — we build AI automation systems for businesses. Need a custom WhatsApp agent, CRM integration, or a full automation stack? [Get in touch](https://bubbles.studio).*

*More Bubbles templates: [Postgres S3 Backup](https://railway.com/deploy/sparkling-creation) · [Webhook Inspector](https://railway.com/deploy/webhook-inspector)*
