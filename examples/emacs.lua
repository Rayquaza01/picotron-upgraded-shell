--[[pod_format="raw",created="2024-12-05 19:36:10",modified="2025-02-15 02:57:33",revision=128]]
-- Adds a few emacs bindings, such as Ctrl+Arrows and Ctrl+W
-- Using some code from /system/lib/gui_ed.lua
-- Install by saving this file to /appdata/system/terminal/emacs.lua

--- Modified from get_char_cat in /system/lib/gui_ed.lua
--- Gets the category of a character
--- @param c string
--- @return integer
local function get_char_cat(c)
	if (string.find("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_", c, 1, true)) then return 1 end
	if (ord(c) >= 128 or ord(c) < 0) then
		return 1
	end

	-- pico-8 0.2.4d: added some operators for pico-8 help system
	if (string.find("@%$", c, 1, true)) then return 3 end
	if (string.find("#^?", c, 1, true)) then return 4 end
	if (string.find("(){}[]<>", c, 1, true)) then return 5 end

	if (string.find("!@#$%^&*:;.,~=+-/\\`'\"", c, 1, true)) then return 2 end

	return 6 -- something else. whitespace
end

--- Modified from calculate_skip_steps in /system/lib/gui_ed.lua
--- Jumps to the next or previous word in in the string from the cursor position
--- Used for Ctrl+Left and Ctrl+Right
--- @param str string
--- @param pos integer
--- @param dir integer
--- @return integer
local function calculate_skip_steps(str, pos, dir)
	local line = str
	local cur_y = 1
	local cur_x = pos + 1

	local pos = cur_x
	local cat0 = 0 -- unknown starting category

	while ((dir < 0 and pos > 1) or (dir > 0 and pos <= #line + 1)) do -- #line + 1 for \n

		if (dir < 0) then pos += dir end

		-- category of current char
		cat = get_char_cat(sub(line,pos,pos));

		-- found a character that disagrees with starting category -> end of span
		if ((cat0 > 0) and (cat ~= cat0)) then
			if (dir > 0 and pos > 0) then pos -= 1 end

			if (cat0 == 6 and cat ~= 6) then
				-- skip whitespace and search for end of non-whitespace
				-- going left: jump to start of word; going right: jump to end of word
				cat0 = cat
			else
				return (pos - cur_x) + 1
			end
		end

		if (cat0 == 0 and cat != 0) then
			cat0 = cat
		end

		if (dir > 0) then pos += dir end
	end

	if (dir > 0 and pos > 1) then pos -= 1 end

	return pos - cur_x
end

local function shortcut(v)
	local cursor_pos = v.cursor_pos
	local cmd = v.cmd

	if key("ctrl") and not key("alt") then
		-- Ctrl+A and Ctrl+E are default

		if keyp("f") then
			cursor_pos = mid(0, cursor_pos + 1, #cmd)
		end

		if keyp("b") then
			cursor_pos = mid(0, cursor_pos - 1, #cmd)
		end

		-- Ctrl+Left and Ctrl+Right jump by words

		if keyp("left") then
			cursor_pos = mid(cursor_pos + calculate_skip_steps(cmd, cursor_pos, -1), 0, #cmd)
		end

		if keyp("right") then
			cursor_pos = mid(cursor_pos + calculate_skip_steps(cmd, cursor_pos, 1), 0, #cmd)
		end

		-- Ctrl+W deletes from the cursor to the previous word

		if keyp("w") then
			local start_del = max(cursor_pos + calculate_skip_steps(cmd, cursor_pos, -1), 0)
			local end_del = cursor_pos
			cmd = sub(cmd, 1, start_del) .. sub(cmd, end_del + 1, #cmd)
			cursor_pos = start_del
		end
	end

	return { cursor_pos = cursor_pos, cmd = cmd }
end

return {
	update = { shortcut }
}
