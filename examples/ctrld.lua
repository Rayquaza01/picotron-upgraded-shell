--[[pod_format="raw",created="2024-12-05 00:14:12",modified="2024-12-05 00:16:50",revision=4]]
-- Allows you to close the terminal window with ctrl+d when command is blank
-- Install by saving this file to /appdata/system/terminal/cd.lua

local function ctrld(cmd)
	if key("ctrl") then
		if keyp("d") and cmd == "" then
			exit()
		end
	end
end

return {
	update = { ctrld }
}
