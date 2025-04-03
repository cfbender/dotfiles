local desiredWidth = 60

local function image_size(dimensions)
	local width, height = dimensions:match("^(%d+)x(%d+)$")

	height = tonumber(height)

	-- find width to match 25px height based on aspect ratio
	local aspect_ratio = tonumber(width) / desiredWidth
	height = math.floor(height / aspect_ratio)
	if height < 1 then
		height = 1
	end

	return { width = desiredWidth, height = height }
end

local function image_data(file, dimensions)
	local size = image_size(dimensions)
	return {
		height = size.height,
		cmd = string.format("chafa %s --format symbols --symbols vhalf --size %sx%s", file, size.width, size.height),
	}
end

local table = {}

local data = {
	{
		name = "sakura",
		file = "~/assets/lo-fi-sakura.webp",
		size = "900x506",
	},
	{
		name = "linville",
		file = "~/assets/linville.png",
		size = "1536x1024",
	},
}

for _, v in pairs(data) do
	data = image_data(v.file, v.size)
	table = vim.tbl_extend("force", table, {
		[v.name] = {
			cmd = data.cmd,
			height = math.ceil(data.height / 2),
		},
	})
end

return table
