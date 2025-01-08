--[[pod_format="raw",created="2024-12-21 04:33:33",modified="2024-12-21 05:09:58",revision=29]]
-- Adds file manager commands
-- Install by saving this file to /appdata/system/terminal/fman.lua

local yanked_files = {}
local cut_files = {}

--- https://github.com/Rayquaza01/enchanted-gemstones/blob/f47d430a438f28000076c1facb836fd4194bf083/enchanted-gemstones/3.p8.lua#L24
--- @param tbl table
--- @param v any
function set_add(tbl, v)
	-- default pos at end of list
	local pos = #tbl + 1
	-- for each item in list
	for i = #tbl, 1, -1 do
		-- if item already in list, return early
		-- each item can only be in list once
		if (tbl[i] == v) then
			return
		end
		-- insert position is sorted
		if (v < tbl[i]) then
			pos = i
		end
		-- break if passed correct position
		if (v > tbl[i]) then
			break
		end
	end
	add(tbl, v, pos)
end

local function yank(argv, push)
	if #argv > 0 then
		if argv[1] == "--clear" then
			yanked_files = {}
			add_line("Cleared yanked files.")
		else
			local c = 0
			for i, file in ipairs(argv) do
				local path = fullpath(file)
				if fstat(path) then
					set_add(yanked_files, path)
					c += 1
				end
			end

			add_line(string.format("Yanked \fe%d\f7 file(s).", c))
		end
	else
		if #yanked_files > 0 then
			add_line("Yanked files:")
			for i, file in ipairs(yanked_files) do
				add_line("\fe" .. file .. "\f7")
			end
		else
			add_line("No yanked files.")
		end
	end
end

local function cut(argv, push)
	if #argv > 0 then
		if argv[1] == "--clear" then
			cut_files = {}
			add_line("Cleared cut files.")
		else
			local c = 0
			for i, file in ipairs(argv) do
				local path = fullpath(file)
				if fstat(path) then
					set_add(cut_files, path)
					c += 1
				end
			end

			add_line(string.format("Cut \fe%d\f7 file(s).", c))
		end
	else
		if #cut_files > 0 then
			add_line("Cut files:")
			for i, file in ipairs(cut_files) do
				add_line("\fe" .. file .. "\f7")
			end
		else
			add_line("No cut files.")
		end
	end
end

local function put()
	if #yanked_files < 1 and #cut_files < 1 then
		add_line("Nothing to put.")
	end

	for i, file in ipairs(yanked_files) do
		local c = 1
		local basename = string.format("%s/%s", pwd(), file:basename())
		local ext = file:ext()
		local name = file:sub(1, #file - #ext - 1)

		while fstat(basename) do
			basename = string.format("%s/%s_%d.%s", pwd(), name, c, ext)
			c += 1
		end

		add_line(string.format("Copied \fe%s\f7 to \fe%s\f7.", file, basename))
		local result = cp(file, basename)
		if result then
			add_line(result)
		end
	end

	for i, file in ipairs(cut_files) do
		local c = 1
		local basename = string.format("%s/%s", pwd(), file:basename())
		local ext = file:ext()
		local name = file:sub(1, #file - #ext - 1)

		while fstat(basename) do
			basename = string.format("%s/%s_%d.%s", pwd(), name, c, ext)
			c += 1
		end

		add_line(string.format("Moved \fe%s\f7 to \fe%s\f7.", file, basename))
		local result = mv(file, basename)
		if result then
			add_line(result)
		end
	end

	yanked_files = {}
	cut_files = {}
end

return {
	commands = {
		yank = yank,
		cut = cut,
		put = put
	}
}
