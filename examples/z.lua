--[[pod_format="raw",created="2024-12-04 23:17:04",modified="2024-12-05 00:13:10",revision=12]]
-- Adds a shortcut to open fzf in folder/clipboard mode
-- Requires fzf (load #fzf, or https://github.com/Rayquaza01/fuzzy-finder-picotron/)
-- Install by saving this file to /appdata/system/terminal/z.lua

local function shortcut()
	if key("alt") and keyp("c") then
		create_process("/appdata/system/util/fzf.p64", {
			argv = {
				"--folders",
				"--no-files",
				"--clipboard"
			}
		})
	end
end

return {
	update = { shortcut }
}
