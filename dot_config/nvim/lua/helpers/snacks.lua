--- Truncates a string to a maximum length, appending an ellipsis if needed.
-- The returned string's length, including the ellipsis, will not exceed max_len.
-- @param str The input string.
-- @param max_len The maximum desired length for the output string.
-- @return The truncated string.
local function truncate(str, max_len)
	if str == nil then
		return ""
	end

	-- If the string is already within the desired length, return it as is.
	if #str <= max_len then
		return str
	end

	local ellipsis = "..."
	local ellipsis_len = #ellipsis

	-- If the max length is too short to even hold the ellipsis,
	-- just chop the string to the max length.
	if max_len <= ellipsis_len then
		return string.sub(str, 1, max_len)
	end

	-- Truncate the string to make space for the ellipsis and append it.
	local truncated_len = max_len - ellipsis_len
	return string.sub(str, 1, truncated_len) .. ellipsis
end

local function pick_biome_search()
	local Snacks = require("snacks")
	local git_root = Snacks.git.get_root()
	-- Get the tree-sitter node at the current cursor position.
	local node = vim.treesitter.get_node()

	local node_text = ""

	if node then
		node_text = vim.treesitter.get_node_text(node, 0)
	end

	local function finder(opts, ctx)
		return require("snacks.picker.source.proc").proc({
			opts,
			{
				cmd = "biome",
				args = { "search", "`" .. node_text .. "`" },
				cwd = git_root,
				transform = function(item)
					local file, line, col = item.text:match("^(.-):(%d+):(%d+)")
					if not file then
						return false
					else
						item.file = file
						item.pos = { tonumber(line), tonumber(col) - 1 }
					end
				end,
			},
		}, ctx)
	end

	Snacks.picker.pick({
		source = "biome_search",
		finder = finder,
		preview = "file",
		title = truncate("Biome search (" .. node_text .. ")", 50),
	})
end

return {
	pick_biome_search = pick_biome_search,
}
