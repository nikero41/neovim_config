---@alias KeymapModes "n"|"i"|"v"|"x"|"o"|"c",

---@class Keymaps
---@field n table
---@field i table
---@field v table
---@field x table
---@field o table
---@field c table
---@field new fun(self: Keymaps, o?: Keymaps): Keymaps
---@field add fun(self: Keymaps, modes: KeymapModes|KeymapModes[], lhs: string, action: string|fun(), opts?: vim.keymap.set.Opts)
local Keymaps = { keymaps = { n = {}, i = {}, v = {}, x = {}, o = {}, c = {} } }

function Keymaps:new(o)
	local k = o or {}
	setmetatable(k, self)
	self.__index = self
	return k
end

function Keymaps:add(modes, lhs, value, opts)
	opts = opts or {}
	if type(modes) == "table" then
		for _, mode in ipairs(modes) do
			self.keymaps[mode][lhs] = { value, opts }
		end
	else
		self.keymaps[modes][lhs] = { value, opts }
	end
end

function Keymaps:setup()
	for mode, lhss in pairs(self.keymaps) do
		for lhs, value in pairs(lhss) do
			vim.keymap.set(mode, lhs, value[1], value[2])
		end
	end
end

return Keymaps
