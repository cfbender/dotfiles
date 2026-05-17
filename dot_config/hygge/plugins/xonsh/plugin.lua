-- Hygge Lua plugin entrypoint.
-- Provides a Xonsh execution tool plus concise guidance for agents.

local XONSH_SYSTEM_PROMPT = [=[
## Xonsh shell preference

When the `xonsh` tool is available, prefer it over Bash for ad-hoc shell work that benefits from Python. Treat Xonsh as Python with shell syntax: use Python expressions/imports for data shaping, `$NAME` for environment variables, `aliases[...]` for aliases, and subprocess syntax such as `$(cmd)` when capturing command output. Fall back to Bash for Bash-specific scripts or syntax.
]=]

local function render_exec_result(command, result)
	local lines = {}
	lines[#lines + 1] = "## Xonsh command result"
	lines[#lines + 1] = ""
	lines[#lines + 1] = "**Command:**"
	lines[#lines + 1] = "```xonsh"
	lines[#lines + 1] = command
	lines[#lines + 1] = "```"
	lines[#lines + 1] = ""
	lines[#lines + 1] = "**Exit code:** " .. tostring(result.code)

	if result.stdout and result.stdout ~= "" then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "**stdout:**"
		lines[#lines + 1] = "```text"
		lines[#lines + 1] = result.stdout
		lines[#lines + 1] = "```"
	end

	if result.stderr and result.stderr ~= "" then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "**stderr:**"
		lines[#lines + 1] = "```text"
		lines[#lines + 1] = result.stderr
		lines[#lines + 1] = "```"
	end

	return table.concat(lines, "\n")
end

hygge.register_hook("pre_message", { name = "xonsh_shell_preference" }, function(_event)
	return {
		decision = "allow",
		system_prompt_append = XONSH_SYSTEM_PROMPT,
	}
end)

hygge.register_tool({
	name = "xonsh",
	description = "Execute a Xonsh command through Hygge's permission engine. Prefer this over Bash when Python-native shell syntax is useful and Xonsh is available.",
	input_schema = {
		type = "object",
		properties = {
			command = {
				type = "string",
				description = "Xonsh code to run with `xonsh -c`. Xonsh is Python plus shell syntax.",
			},
			dir = {
				type = "string",
				description = "Optional working directory. Defaults to the session directory.",
			},
			timeout = {
				type = "string",
				description = "Optional Go-style duration such as `30s`, `2m`, or `500ms`. Defaults to `30s`.",
			},
		},
		required = { "command" },
		additionalProperties = false,
	},
	execute = function(_ctx, input)
		if not input or type(input.command) ~= "string" or input.command == "" then
			return { content = "`command` is required and must be a non-empty string.", is_error = true }
		end

		local opts = { timeout = input.timeout or "30s" }
		if input.dir and input.dir ~= "" then
			opts.dir = input.dir
		end

		local probe = hygge.exec("sh", { "-c", "command -v xonsh" }, { timeout = "5s" })
		if probe.code ~= 0 then
			return {
				content = "Xonsh is not available on PATH. Install `xonsh`, or use Bash for this command.",
				is_error = true,
			}
		end

		local result = hygge.exec("xonsh", { "-c", input.command }, opts)
		return {
			content = render_exec_result(input.command, result),
			is_error = result.code ~= 0,
		}
	end,
})
