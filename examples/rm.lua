--[[pod_format="raw",created="2024-12-05 02:29:19",modified="2024-12-05 02:30:17",revision=1]]
-- Replaces rm with trash
-- Install by saving this file to /appdata/system/terminal/pwd_title.lua

local function trash_rm(argv, push)
	if #argv > 0 then
		push.run_terminal_command("trash " .. table.concat(argv, " "))
	else
		add_line("Usage: rm filename")
	end
end

return {
	commands = {
		rm = trash_rm
	}
}
