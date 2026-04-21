import type { Plugin } from "@opencode-ai/plugin"

// OpenRouter session tracking plugin.
//
// Injects the OpenCode session ID as `x-session-id` on outgoing OpenRouter
// requests so related requests are grouped together in the OpenRouter
// dashboard (https://openrouter.ai/docs/api-reference/chat-completion —
// `session_id` body field / `x-session-id` header, max 256 chars).
//
// HTTP-Referer / X-Title are intentionally omitted: OpenCode already sets
// its own app attribution on the OpenRouter request.
//
// Note: the shipped `@opencode-ai/plugin` types describe provider as
// `{ source, info: Provider, options }` but the current OpenCode source
// passes the flat `Provider` object (with `id` on top). We handle both
// shapes defensively so this works across versions.

export const OpenRouterSessionPlugin: Plugin = async ({ client }) => {
  const log = (message: string, extra?: Record<string, unknown>) =>
    client.app
      .log({ body: { service: "openrouter-session", level: "info", message, extra } })
      .catch(() => {})

  return {
    "chat.headers": async (input, output) => {
      const p = (input as any).provider
      const providerId: string | undefined = p?.id ?? p?.info?.id
      if (providerId !== "openrouter") return
      if (!input.sessionID) return
      output.headers["x-session-id"] = input.sessionID
      await log("injected x-session-id", { sessionID: input.sessionID })
    },
  }
}

export default OpenRouterSessionPlugin
