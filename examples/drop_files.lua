--[[pod_format="raw",created="2025-01-16 04:02:02",modified="2025-01-16 04:13:00",revision=8]]
-- Allows you to insert filenames by dragging a file into the terminal
-- Install by saving this file to /appdata/system/terminal/drop_files.lua

local function add_drop_listener()
	on_event("drop_items", function (msg)
		local items = {}
		for item in all(msg.items) do
			add(items, item.fullpath)
		end

		local v = _get_push_vars()
		local items_str = table.concat(items, " ")
		local cmd = v.cmd:sub(-1, -1) == " " and
			v.cmd .. items_str or
			v.cmd .. " " .. items_str

		_set_push_vars({
			cmd = cmd,
			cursor_pos = #cmd
		})
	end)
end

return {
	init = { add_drop_listener }
}
