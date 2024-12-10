--[[pod_format="raw",created="2024-12-10 04:20:48",modified="2024-12-10 04:31:25",revision=11]]
-- Adds a history command to view and run previous command history
-- Install by saving this file to /appdata/system/terminal/history.lua

local function history(argv, push)
	if #argv > 0 then
		local num = tonumber(argv[1])
		if num > 1 and num <= #push.history then
			push.run_terminal_command(push.history[num])
		else
			for i = 1, #push.history, 1 do
				if push.history[i]:find(argv[1], 1, true) then
					add_line(string.format("\fe%02d\f7\t\t%s", i, push.history[i]))
				end
			end
		end
	else
		for i = max(#push.history - 25, 1), #push.history, 1 do
			add_line(string.format("\fe%02d\f7\t\t%s", i, push.history[i]))
		end
	end
end

return {
	commands = {
		history = history
	}
}
