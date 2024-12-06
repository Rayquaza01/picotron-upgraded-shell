--[[pod_format="raw",created="2024-12-06 02:48:46",modified="2024-12-06 03:59:18",revision=10]]
-- Adds bare cd and bare dots command handlers, as well as an up command
-- Install by saving this file to /appdata/system/terminal/barecd.lua

local function bare_cd(cmd, push)
	if fstat(cmd) == "folder" then
		push.commands.cd({ cmd }, push)
		return true
	end

	return false
end

local function up(argv, push)
	if #argv > 0 then
		local n = tonum(argv[1])

		if n then
			local path = {}
			for i = 1, n, 1 do
				add(path, "..")
			end

			local path_str = table.concat(path, "/")
			if fstat(path_str) == "folder" then
				push.commands.cd({ path_str }, push)
			end
		end
	end
end

local function n_dots(cmd, push)
	if cmd:find("^%.%.+$") then
		up({ #cmd - 1 }, push)

		return true
	end

	return false
end

return {
	command_handlers = {
		bare_cd,
		n_dots,
	},
	commands = {
		up = up
	}
}
