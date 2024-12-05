--[[pod_format="raw",created="2024-12-05 17:46:19",modified="2024-12-05 18:36:01",revision=40]]
--- Get the token at the position in the string
--- @param str string
--- @param pos integer
--- @returns string
local function get_token(str, pos)
	local tokens = split(str, " ", false)

	local current_position = 1
	for i, token in ipairs(tokens) do
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

			if fstat(token) == "folder" then
				add_line(v.get_prompt()..v.cmd)
				v.run_terminal_command("ls " .. token)
			else
				add_line(v.get_prompt()..v.cmd)
				v.run_terminal_command("ls")
			end
		end
	end
end

return {
	update = { shortcut }
}