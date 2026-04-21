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

export const OpenRouterSessionPlugin: Plugin = async () => {
  return {
    "chat.headers": async (input, output) => {
      if (input.provider?.info?.id !== "openrouter") return
      if (!input.sessionID) return
      output.headers["x-session-id"] = input.sessionID
    },
  }
}

export default OpenRouterSessionPlugin
