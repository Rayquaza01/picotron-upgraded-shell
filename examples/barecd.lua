--[[pod_format="raw",created="2024-12-06 02:48:46",modified="2025-02-18 16:03:43",revision=11]]
-- Adds bare cd and bare dots command handlers, as well as an up command
-- Install by saving this file to /appdata/system/terminal/barecd.lua

local function bare_cd(cmd, push)
	-- if command starts with ./ and is a cart, don't cd into it
	-- execute it instead
	if cmd:find("^%./") and (cmd:find("%.p64$") or cmd:find("%.p64%.png$") or cmd:find("%.rom$")) then
		return false
	end

	if pwd():prot() == "bbs" then
		return false
	end

	-- don't cd into bbs
	if cmd:prot() == "bbs" then
		return false
	end

	-- don't cd into any carts
	-- if cmd:find("%.p64$") or cmd:find("%.p64%.png$") or cmd:find("%.rom$") then
	-- 	return false
	-- end

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
