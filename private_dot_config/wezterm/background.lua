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
		source = {
			File = one,
		},
	}
end

return M
