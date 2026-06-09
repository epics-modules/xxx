-- settings.lua
--
-- Generic settings loader for EPICS IOC Lua scripts.
-- Loads a Lua table from a settings file, applies per-item defaults
-- via metatables, and provides a macros() method for building EPICS
-- macro strings.
--
-- Usage:
--   settings = require("settings")
--   data = settings.load("settings/my-device", defaults_table)
--
--   for index, item in ipairs(data) do
--       dbLoadRecords("file.db", item:macros{"FIELD1", "FIELD2", KEY="value"})
--   end

local settings = {}

local function macros(self, fields)
	local output = ""
	local replace_items = {}

	for key, value in pairs(fields) do
		if type(value) == "table" then
			output = output .. self:macros(value)
		else
			local name, val

			if type(key) == "number" then
				name = value
				val = self[value]
			else
				name = key
				val = value
			end

			replace_items[name] = val
			output = output .. string.format("%s=%s,", name, val)
		end
	end

	local replace_list = {}

	for substring in output:gmatch "%$%(([%w_]+)%)" do
		replace_list[#replace_list + 1] = substring
	end

	for _, name in ipairs(replace_list) do
		if replace_items[name] ~= nil then
			output = string.gsub(output, "%$%(" .. name .. "%)", replace_items[name])
		end
	end

	return output:gsub(",$", "")
end

function settings.load(settings_file, defaults)
	defaults = defaults or {}

	if not settings_file then
		error("settings.load: settings_file parameter is required")
	end

	local data = require(settings_file)

	local meta = {}
	meta.macros = macros

	-- Copy all non-numeric keys from the settings file as section-level defaults
	for key, value in pairs(data) do
		if type(key) ~= "number" then meta[key] = value end
	end

	setmetatable(meta, {__index=defaults})

	local output = {}

	-- Each numeric entry inherits from section defaults, then script defaults
	for index, item in ipairs(data) do
		setmetatable(item, {__index=meta})
		output[index] = item
	end

	setmetatable(output, {__index=meta})

	return output
end

return settings
