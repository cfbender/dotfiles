local desiredWidth = 60

local function getHeight(width, height)
	local aspect_ratio = tonumber(width) / desiredWidth
	height = math.floor(height / aspect_ratio)
	if height < 1 then
		height = 1
	end

	return height
end

local function imageData(file)
	-- get image dimensions from file command
	local result = vim.fn.system({
		"file",
		vim.fn.fnamemodify(file, ":p"),
	})
	local width, height = string.match(result, "(%d+)%s*x%s*(%d+)")

	return {
		height = getHeight(width, height),
		cmd = string.format("chafa %s --format symbols --symbols vhalf --fit-width --view-size %s", file, desiredWidth),
	}
end

local table = {}

local path = vim.fn.expand("~/assets")
local files = vim.fn.readdir(path)

local function is_image_file(filename)
	return filename:lower():match("%.jpe?g$") or filename:lower():match("%.png$") or filename:lower():match("%.webp$")
end
local function trim_extension(filename)
	return filename:match("^(.*)%.[^%.]+$") or filename
end

for _, file in ipairs(files) do
	local fullpath = path .. "/" .. file
	if vim.fn.isdirectory(fullpath) == 0 and is_image_file(file) then
		local data = imageData(fullpath)
		table = vim.tbl_extend("force", table, {
			[trim_extension(file)] = {
				cmd = data.cmd,
				height = math.ceil(data.height / 2),
			},
		})
	end
end

return table
