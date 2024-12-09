--[[pod_format="raw",created="2024-12-05 00:14:12",modified="2024-12-05 00:16:50",revision=4]]
-- Allows you to clear the cmd with Ctrl+C
-- Install by saving this file to /appdata/system/terminal/ctrlc.lua

local function ctrlc(v)
	if key("ctrl") and not key("alt") then
		if keyp("c") then
			if v.cmd ~= "" then
				add_line(v.get_prompt() .. v.cmd .. "\f8^C\f7")
			end
			return { cmd = "" }
		end
	end
end

return {
	update = { ctrlc }
}
