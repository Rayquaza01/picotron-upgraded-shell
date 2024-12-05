--[[pod_format="raw",created="2024-12-05 17:36:46",modified="2024-12-05 17:38:40",revision=3]]
local function source(argv)
	if argv[1]:find(".lua$") and fstat(argv[1]) == "file" then
		include(argv[1])
	else
		if argv[1] ~= nil then
			add_line("could not source " .. argv[1])
		end
	end
end

return {
	commands = {
		source = source
	}
}