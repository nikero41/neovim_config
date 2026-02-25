---@class Helpers
---@field index_of fun(self: Helpers, array: table, value: any): number|nil
---@field remove_list_value fun(self: Helpers, list: table, value: any): any|nil
---@field check_json_key_exists fun(self: Helpers, filename: string, key: string): boolean
---@field get_highlight fun(self: Helpers, name: string): { foreground: string?, background: string?, special: string?}?
---@field hex_to_rgb fun(self: Helpers, hex_str: string): string[]
---@field blend fun(self: Helpers, fg: string, bg: string, alpha: number): string
local Helpers = {}

function Helpers:index_of(array, value)
	for i, v in ipairs(array) do
		if v == value then return i end
	end
	return nil
end

function Helpers:remove_list_value(list, value)
	local index = self:index_of(list, value)
	if index then return table.remove(list, index) end
	return nil
end

function Helpers:check_json_key_exists(filename, key)
	local file = io.open(filename, "r")
	if not file then return false end

	local content = file:read("*all")
	file:close()

	local json_parsed, json = pcall(vim.fn.json_decode, content)
	if not json_parsed or type(json) ~= "table" then return false end

	return json[key] ~= nil
end

function Helpers:get_highlight(name)
	local ok, hl = pcall(vim.api.nvim_get_hl, name, true)
	if not ok then return end
	for _, key in pairs({ "foreground", "background", "special" }) do
		if hl[key] then hl[key] = string.format("#%06x", hl[key]) end
	end
	return hl
end

function Helpers:hex_to_rgb(hex_str)
	local hex = "[abcdef0-9][abcdef0-9]"
	local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
	hex_str = string.lower(hex_str)

	assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

	local red, green, blue = string.match(hex_str, pat)
	return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function Helpers:blend(fg_hex, bg_hex, alpha)
	local bg = self:hex_to_rgb(bg_hex)
	local fg = self:hex_to_rgb(fg_hex)

	local blendChannel = function(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

return Helpers
