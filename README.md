# WhatsApp AI Receptionist — a working AI agent on your WhatsApp number, 24/7

Deploy a **complete, working AI receptionist** for your business WhatsApp number in one click — not raw API plumbing. A customer messages your number; an AI agent (Claude or GPT, using **your own API key**) answers instantly with your business context, hands off to a human on request, and sends an office-hours auto-reply when you're closed.

Built on battle-tested open source: [Evolution API](https://github.com/EvolutionAPI/evolution-api) (9.3k★) for the WhatsApp connection and [n8n](https://github.com/n8n-io/n8n) (201k★) for the agent workflow — preloaded and wired together, so it works the moment you scan a QR code.

**Who it's for:** clinics, salons, restaurants, real-estate agents, e-commerce stores, agencies — any business that gets WhatsApp messages faster than a human can answer them, and any builder who wants a self-hosted WhatsApp + AI foundation to customize.

## Why not Twilio / a SaaS chatbot?

| | This template | Twilio WhatsApp + bot SaaS |
|---|---|---|
| Platform fees | **$0** — flat Railway usage (~$10–15/mo typical) | ~$0.005/msg + Meta conversation fees + $29–99/mo bot SaaS seat |
| 3,000 conversations/mo | ~$10–15 + your LLM usage (~$1–3 with Claude Haiku) | $75–250+ |
| Your data | Your database, your infra | Vendor's cloud |
| Customization | Full n8n visual editor — add CRM, Sheets, calendars | Whatever the SaaS allows |

No per-message fees, no per-seat fees, no conversation caps. You pay Railway for compute and your LLM provider for tokens — both scale with actual usage.

## What gets deployed (4 services)

| Service | Version | Role |
|---|---|---|
| **Evolution API** | `v2.3.7` (pinned by tag + sha256 digest) | WhatsApp gateway — QR pairing, send/receive, manager UI |
| **n8n** | `2.35.3` (pinned by tag + sha256 digest) | Preloaded "WhatsApp AI Receptionist" workflow (auto-imported and active) |
| **PostgreSQL** | Railway managed | Sessions, messages, contacts + n8n data (separate schema) |
| **Redis** | Railway managed | Evolution cache — fast instance/session lookups |

- **All internal traffic stays on Railway's private network** — Postgres, Redis, and the Evolution↔n8n webhook are never exposed publicly.
- **Session persistence:** WhatsApp auth lives in Postgres **and** a volume mounted at `/evolution/instances`. **Survives restarts and redeploys — no QR re-scan.**
- Versions are pinned by digest and only bumped through reviewed PRs, checked weekly against upstream. Evolution is deliberately kept on the v2.3.x line (v2.4.0+ requires a license activation).

## Setup (~5 minutes)

1. Click **Deploy Now**, paste your **Anthropic (or OpenAI) API key**, your **business name**, and a short **system prompt** describing your business (services, prices, address, tone). Everything else is auto-generated.
2. Wait for the four services to go green, then open the Evolution API service's URL at `/manager` and log in with the `AUTHENTICATION_API_KEY` (find it under the Evolution service → Variables).
3. Create an instance (any name, e.g. `reception`), choose **Baileys**, and scan the QR code from your business phone: WhatsApp → Settings → Linked devices.
4. Send a WhatsApp message to that number from another phone. The AI answers in seconds. Done — it's live 24/7.
5. *(Optional)* Open the n8n service URL, create your owner account, and see the receptionist workflow — extend it with any of n8n's 400+ integrations.
6. *(Optional)* Set `OFFICE_HOURS` (e.g. `09:00-18:00`) and `GENERIC_TIMEZONE` (e.g. `America/New_York`) on the n8n service for the after-hours auto-reply.

**Built-in behaviors:** instant AI answers with your business context · human handoff (customer types `human` — configurable via `HANDOFF_KEYWORD` — and the bot steps aside with a courtesy message) · office-hours auto-reply · groups and your own outgoing messages are ignored automatically.

## Use cases

- **After-hours receptionist** — answer questions about hours, location, pricing, availability while you sleep
- **Lead qualification** — greet inbound leads instantly, collect intent, hand off hot ones to a human
- **Booking assistant** — extend the n8n workflow with Google Calendar or Cal.com nodes to take reservations
- **Order/FAQ support for e-commerce** — connect n8n to Sheets, Airtable, or your store's API for live answers
- **Foundation stack** — the same Evolution + n8n pairing powers Chatwoot, Typebot, Dify, and Flowise integrations; swap our workflow for anything

## FAQ

**Does my WhatsApp session survive redeploys?** Yes. Session auth is stored in Postgres and on a persistent volume. Restart, redeploy, or upgrade — no QR re-scan.

**Which AI models can I use?** Default is Anthropic's Claude Haiku (fast, ~$1–3/mo for thousands of messages). Set `LLM_PROVIDER=openai` for GPT models, or `LLM_MODEL` to any model id (e.g. `claude-sonnet-4-6`). Your key, your costs, no markup.

**Does the bot remember conversation history?** Out of the box each message is answered independently (with your full business context). Multi-turn memory is a straightforward n8n extension — the workflow is yours to edit.

**What does it cost to run?** Typically **$10–15/mo** on Railway for an always-on 4-service stack, plus your LLM tokens. Usage-based — a quiet number costs less.

**Can I get banned? Is this official?** This uses Evolution API, an **unofficial** WhatsApp client built on Baileys (WhatsApp Web protocol). It is **not affiliated with, endorsed by, or supported by Meta/WhatsApp**. Accounts that spam or mass-message can be restricted or banned — use a dedicated business number, reply to inbound messages rather than broadcasting, and avoid cold outreach. For regulated or mission-critical workloads, use the official WhatsApp Business API instead.

**How do upgrades work?** Images are pinned by version + digest. We check upstream weekly and ship reviewed bumps; redeploying picks them up with no data loss. Evolution stays on v2.3.x (v2.4.0+ introduced mandatory license activation).

**Can I edit the AI's behavior after deploying?** Yes — change `SYSTEM_PROMPT`, `OFFICE_HOURS`, `HANDOFF_KEYWORD`, etc. in the n8n service Variables (takes effect immediately), or open n8n and edit the workflow visually. Note: redeploying the n8n service re-imports the stock workflow under its original ID — if you customize it, **Save As a copy first**.

## Security notes

- All credentials live in **Railway Variables** — nothing sensitive is baked into images or the repo.
- `AUTHENTICATION_API_KEY` (Evolution) and the n8n encryption key are **auto-generated per deploy**. Treat the Evolution key like a password — anyone holding it can send messages as your number.
- On first visit to n8n you'll create an **owner account** — use a strong password.
- Databases, Redis, and the Evolution↔n8n webhook are reachable **only on the private network**.
- Volume-backed services run a **single replica** (do not scale Evolution horizontally; sessions are stateful).

---

*Built by [Bubbles Studio](https://bubbles.studio) — we build AI automation systems for businesses. Need a custom WhatsApp agent, CRM integration, or a full automation stack? [Get in touch](https://bubbles.studio).*
