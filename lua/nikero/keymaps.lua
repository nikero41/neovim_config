---@alias KeymapModes "n"|"i"|"v"|"x"|"o"|"c",

---@class Keymaps
---@field n table
---@field i table
---@field v table
---@field x table
---@field o table
---@field c table
---@field new fun(self: Keymaps, o?: Keymaps): Keymaps
---@field add fun(self: Keymaps, mode: KeymapModes | KeymapModes[], lhs: string, value: table|false): nil
---@field create fun(self: Keymaps): table
local Keymaps = { n = {}, i = {}, v = {}, x = {}, o = {}, c = {} }

function Keymaps:new(o)
	local k = o or {}
	setmetatable(k, self)
	self.__index = self
	return k
end

function Keymaps:add(modes, lhs, value)
	if type(modes) == "table" then
		for _, mode in ipairs(modes) do
			self[mode][lhs] = value
		end
	else
		self[modes][lhs] = value
	end
end

function Keymaps:create()
	return { n = self.n, i = self.i, v = self.v, x = self.x, o = self.o, c = self.c }
end

return Keymaps
