--[[pod_format="raw",created="2024-12-05 00:14:12",modified="2024-12-05 00:16:50",revision=4]]
-- Allows you to clear the cmd with Ctrl+C
-- Install by saving this file to /appdata/system/terminal/ctrlc.lua

local function ctrlc()
	if key("ctrl") and keyp("c") then
		return { cmd = "" }
	end
end

return {
	update = { ctrlc }
}
