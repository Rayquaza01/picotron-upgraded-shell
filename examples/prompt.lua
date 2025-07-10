--[[pod_format="raw",created="2024-12-04 22:07:21",modified="2024-12-05 00:00:56",revision=29]]
-- Changes the prompt to have the current directory be brighter
-- Install by saving this file to /appdata/system/terminal/prompt.lua

local function prompt()
	local input_prompt = _get_push_vars().input_prompt
	if input_prompt then
		return input_prompt.str -- reading some user text
	end

	local path = split(pwd(), "/", false)
	path[#path] = "\fc" .. path[#path]

	return "\fg" .. table.concat(path, "/") .. "\fb$\f7 "
end

return {
	prompt = prompt
}
