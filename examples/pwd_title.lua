--[[pod_format="raw",created="2024-12-05 02:29:19",modified="2024-12-05 02:30:17",revision=1]]
-- Changes the window title to contain the present working directory
-- Install by saving this file to /appdata/system/terminal/pwd_title.lua

local function update_title()
	window({
		title = "PUSH : " .. pwd()
	})
end

return {
	update = { update_title }
}
