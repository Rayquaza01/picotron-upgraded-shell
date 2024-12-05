--[[pod_format="raw",created="2024-12-05 17:46:19",modified="2024-12-05 18:36:01",revision=40]]
-- Adds fish style alt+l to list the current directory, or the directory under the cursor
-- Install by saving this file to /appdata/system/terminal/altl.lua

--- Get the token at the position in the string
--- @param str string
--- @param pos integer
--- @return string
local function get_token(str, pos)
	local tokens = split(str, " ", false)

	local current_position = 1
	for _, token in ipairs(tokens) do
		local end_position = current_position + #token
		if pos >= current_position and pos <= end_position then
			return token
		end

		-- add one to account for spaces
		current_position = end_position + 1
	end

	return tokens[#tokens]
end

local function shortcut(v)
	if key("alt") then
		if keyp("l") then
			local token = get_token(v.cmd, v.cursor_pos + 1)

			-- if cursor is under a folder, then list that folder
			if fstat(token) == "folder" then
				add_line(v.get_prompt()..v.cmd)
				v.run_terminal_command("ls " .. token)
			else
				-- if cursor is under a partially typed path, list up to last /
				local path_components = split(token, "/", false)
				deli(path_components)
				local partial_path = table.concat(path_components, "/")

				if fstat(partial_path) == "folder" then
					add_line(v.get_prompt()..v.cmd)
					v.run_terminal_command("ls " .. partial_path)
				else
					-- if couldn't find path under cursor, list pwd
					add_line(v.get_prompt()..v.cmd)
					v.run_terminal_command("ls")
				end
			end
		end
	end
end

return {
	update = { shortcut }
}
