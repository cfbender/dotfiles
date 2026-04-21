import type { Plugin } from "@opencode-ai/plugin"

// OpenRouter session tracking plugin.
//
// Injects the OpenCode *root* session ID as `x-session-id` on outgoing
// OpenRouter requests so all activity for a single user-facing session —
// including subagent (child) sessions spawned via the Task tool — rolls up
// into one group in the OpenRouter dashboard.
// (https://openrouter.ai/docs/api-reference/chat-completion —
// `session_id` body field / `x-session-id` header, max 256 chars).
//
// OpenCode's Session type carries an optional `parentID`. Subagents run in
// their own session whose `parentID` points at the caller. We walk the
// chain until we find a session with no `parentID` — that is the root —
// and cache the mapping so we only pay the API cost once per child.
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

  // sessionID -> rootSessionID. Parent chains are immutable so cache forever.
  const rootCache = new Map<string, string>()
  // In-flight lookups so concurrent requests on the same session share work.
  const inflight = new Map<string, Promise<string>>()

  const resolveRoot = async (sessionID: string): Promise<string> => {
    const cached = rootCache.get(sessionID)
    if (cached) return cached
    const pending = inflight.get(sessionID)
    if (pending) return pending

    const job = (async () => {
      let currentID = sessionID
      const visited = new Set<string>()
      // Walk parentID chain. Guard against cycles and runaway depth.
      for (let i = 0; i < 32; i++) {
        if (visited.has(currentID)) break
        visited.add(currentID)

        // If we already know the root for this ancestor, short-circuit.
        const known = rootCache.get(currentID)
        if (known) {
          currentID = known
          break
        }

        try {
          const res = await (client as any).session.get({
            path: { id: currentID },
            throwOnError: true,
          })
          const session = res?.data ?? res
          const parentID: string | undefined = session?.parentID
          if (!parentID) break
          currentID = parentID
        } catch (err) {
          await log("session.get failed; using current id as root", {
            sessionID: currentID,
            error: String(err),
          })
          break
        }
      }

      // Cache root for every visited node so future lookups are O(1).
      for (const id of visited) rootCache.set(id, currentID)
      rootCache.set(currentID, currentID)
      return currentID
    })()

    inflight.set(sessionID, job)
    try {
      return await job
    } finally {
      inflight.delete(sessionID)
    }
  }

  return {
    "chat.headers": async (input, output) => {
      const p = (input as any).provider
      const providerId: string | undefined = p?.id ?? p?.info?.id
      if (providerId !== "openrouter") return
      if (!input.sessionID) return

      const rootID = await resolveRoot(input.sessionID)
      output.headers["x-session-id"] = rootID
      if (rootID !== input.sessionID) {
        await log("injected x-session-id (rolled up to root)", {
          sessionID: input.sessionID,
          rootSessionID: rootID,
        })
      } else {
        await log("injected x-session-id", { sessionID: rootID })
      }
    },
  }
}

export default OpenRouterSessionPlugin
