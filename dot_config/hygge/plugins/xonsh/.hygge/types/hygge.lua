---@meta

---Hygge's Lua plugin API.
---
---This file is a LuaLS/LuaCATS definition stub. It is loaded by editors for
---completion, hover text, and diagnostics; it is not executed by Hygge.

---@class Hygge
---@field config table<string, any> Plugin-specific `[plugins.<name>]` config from `config.toml`.
---@field session HyggeSession Current session metadata. Empty during plugin initialisation.
hygge = {}

---@class HyggeSession
---@field id string Current session ID when available.

---@class HyggeToolSpec
---@field name string Stable tool identifier. Must match `[a-z][a-z0-9_]*`.
---@field description string One- or two-sentence model-facing description.
---@field input_schema? table JSON Schema object passed to the model.
---@field parallelizable? boolean True only for read-only/commutative tools.
---@field execute fun(ctx: HyggeToolContext, input: table|nil): HyggeToolResult|string|nil Tool handler.

---@class HyggeToolContext
---@field input? table Decoded JSON tool input, when present.

---@class HyggeToolResult
---@field content string Tool output shown to the model.
---@field is_error? boolean Whether this is a normal tool-level error result.

---Register a model-callable tool.
---@param spec HyggeToolSpec
function hygge.register_tool(spec) end

---@alias HyggeHookEvent
---| 'pre_tool'
---| 'post_tool'
---| 'pre_message'
---| 'post_message'

---@alias HyggeHookMode
---| 'sync'
---| 'async'

---@alias HyggeHookDecision
---| 'allow'
---| 'deny'
---| 'modify'

---@class HyggeHookOptions
---@field name? string Explicit hook name. Defaults to `plugin:<plugin>:<event>`.
---@field mode? HyggeHookMode Defaults to `sync`.
---@field timeout? string Go duration string, for example `2s` or `500ms`.

---@class HyggeHookInput
---@field event HyggeHookEvent
---@field session_id string
---@field hook_name string
---@field pwd string
---@field tool_name string
---@field message string
---@field mode_name string Active mode name when the hook was invoked by a mode switch refresh.
---@field tool_input? table

---@class HyggeHookAction
---@field decision? HyggeHookDecision
---@field reason? string Human-readable reason for deny/allow decisions.
---@field modified_tool_input? table Replacement tool input for pre-tool hooks.
---@field modified_message? string Replacement message for pre-message hooks.
---@field system_prompt_append? string One-turn system prompt addition for pre-message hooks. Not rendered as user text.

---Register a hook for a tool/message event.
---@overload fun(event: HyggeHookEvent, handler: fun(event: HyggeHookInput): HyggeHookAction|nil)
---@param event HyggeHookEvent
---@param options HyggeHookOptions
---@param handler fun(event: HyggeHookInput): HyggeHookAction|nil
function hygge.register_hook(event, options, handler) end

---@class HyggeCommandSpec
---@field name string Slash command name without the leading `/`.
---@field description string One-line command summary.
---@field execute fun(ctx: table, input: string): HyggeCommandResult|string|nil Command handler.

---@class HyggeCommandResult
---@field message string Text shown as the command outcome.

---Register a slash command.
---@param spec HyggeCommandSpec
function hygge.register_command(spec) end

---@class HyggeSubagentSpec
---@field name string Stable subagent type identifier.
---@field description string One-line summary shown to the model.
---@field system_prompt string Full system prompt for the subagent.
---@field tools? string[] Tool-name allowlist. Empty/nil uses default subagent tools.
---@field model? string Optional `<provider>/<model-id>` override.

---Register a subagent type.
---@param spec HyggeSubagentSpec
function hygge.register_subagent(spec) end

---@alias HyggeMessageRole
---| 'user'
---| 'assistant'

---Inject a message into a session on behalf of this plugin.
---@param session_id string
---@param role HyggeMessageRole
---@param content string
function hygge.send_message(session_id, role, content) end

---@alias HyggeLogLevel
---| 'debug'
---| 'info'
---| 'warn'
---| 'error'

---@alias HyggeNotifyLevel
---| 'info'
---| 'warn'
---| 'error'

---Show a user-visible notification.
---@param message string
---@param level? HyggeNotifyLevel Defaults to `info`.
function hygge.notify(message, level) end

---Write a structured plugin log entry.
---@param level HyggeLogLevel
---@param message string
---@param fields? table<string, any>
function hygge.log(level, message, fields) end

---@class HyggeExecOptions
---@field dir? string Working directory. Empty means the session pwd.
---@field timeout? string Go duration string. Defaults to `30s`.

---@class HyggeExecResult
---@field stdout string
---@field stderr string
---@field code integer Process exit code.

---Run a subprocess through Hygge's permission engine.
---@param command string
---@param args? string[]
---@param opts? HyggeExecOptions
---@return HyggeExecResult
function hygge.exec(command, args, opts) end
