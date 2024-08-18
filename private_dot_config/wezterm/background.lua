local math = require("math")
local wezterm = require("wezterm")
local M = {}

function M.random_bk()
	local last_file = wezterm.GLOBAL.last_file
	local files = wezterm.glob(wezterm.config_dir .. "/backgrounds/*.jpg")

	if #files == 0 then
		return {}
	end

	-- Remove last_file from files, to avoid showing the same file twice
	if last_file and #files > 1 then
		for i, v in ipairs(files) do
			if v == last_file then
				table.remove(files, i)
				break
			end
		end
	end

	local one = files[math.random(#files)]
	wezterm.GLOBAL.last_file = one
	return {
		{
			source = {
				File = one,
			},
		},
		{
			source = { Color = "#1f1f28" },
			height = "100%",
			width = "100%",
			opacity = 0.90,
		},
	}
end

function M.gif()
	return {
		{
			source = { Color = "#4f4f4f" },
			height = "100%",
			width = "100%",
			opacity = 0.90,
		},
		{
			vertical_align = "Bottom",
			horizontal_align = "Right",
			width = "40%",
			height = "40%",
			repeat_x = "NoRepeat",
			repeat_y = "NoRepeat",
			source = {
				File = "/Users/zekin/Downloads/飞书20240804-145952.gif",
			},
		},
		{
			source = { Color = "#1f1f28" },
			height = "100%",
			width = "100%",
			opacity = 0.90,
		},
	}
end

return M
