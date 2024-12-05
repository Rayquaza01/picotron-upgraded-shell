--[[pod_format="raw",created="2024-12-05 00:18:29",modified="2024-12-05 01:16:41",revision=61]]
-- Adds fish style cd history
-- Install by saving this file to /appdata/system/terminal/cd.lua

local cd_position = 1
local cd_history = {pwd()}

local function ncd(argv)
	local newpath = fullpath(argv[1] or "/")

	if newpath ~= cd_history[#cd_history] then
		local result = cd(argv[1] or "/")
		if result then
			add_line(result)
		else
			if cd_position ~= #cd_history then
				add(cd_history, cd_history[cd_position])
				deli(cd_history, cd_position)
			end

			del(cd_history, newpath)
			add(cd_history, newpath)
			cd_position = #cd_history

			while #cd_history > 25 do
				deli(cd_history, 1)
			end
		end
	end
end

-- Navigate cd history
-- If no arguments, show history
-- If argument is a number, switch to that number to that number
local function cdh(argv)
	if #argv > 0 and argv[1]:find("^%d+$") then
		-- if argument is in history, and isn't the current item, then select it
		local index = tonum(argv[1])
		if index > 0 and index <= #cd_history and index ~= cd_position then
			ncd({ cd_history[index] })
		end
	else
		-- list all history, except currently selected history item
		for i = 1, #cd_history, 1 do
			if i ~= cd_position then
				add_line(string.format("\fe%02d\f7\t\t%s", i, cd_history[i]))
			end
		end
	end
end

-- Adds shortcuts to navigate command history
-- ctrl + p moves to previous directory
-- ctrl + n moves to next directory
local function shortcuts()
	if key("ctrl") then
		if keyp("p") then
			cd_position = mid(cd_position - 1, 1, #cd_history)
			cd(cd_history[cd_position])
		end

		if keyp("n") then
			cd_position = mid(cd_position + 1, 1, #cd_history)
			cd(cd_history[cd_position])
		end
	end
end

return {
	commands = {
		cd  = ncd,
		cdh = cdh
	},
	update = { shortcuts }
}
