local maxHeight = 34

local function image_size(dimensions)
	if not dimensions or type(dimensions) ~= "string" then
		return nil
	end

	local width, height = dimensions:match("^(%d+)x(%d+)$")
	if not width or not height then
		return nil
	end

	width = tonumber(width)

	-- find width to match 25px height based on aspect ratio
	local aspect_ratio = tonumber(height) / maxHeight
	width = math.floor(width / aspect_ratio)
	if width < 1 then
		width = 1
	end

	return tonumber(width), maxHeight * 2
end

local function command(file, dimensions)
	if not file or not dimensions then
		return ""
	end
	local size = image_size(dimensions)
	return string.format("chafa %s --format symbols --symbols vhalf --size %s", file, size)
end

local table = {}
local data = {
	{
		name = "sakura",
		file = "~/assets/lo-fi-sakura.webp",
		size = "900x506",
	},
}
for _, v in pairs(data) do
	table = vim.tbl_extend("force", table, {
		[v.name] = {
			cmd = command(v.file, v.size),
			height = 17, -- half height for vhalf symbols
		},
	})
end

return table
