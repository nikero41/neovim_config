---@alias KeymapModes "n"|"i"|"v"|"x"|"o"|"c",
---@alias Keymap { [1]: KeymapModes | KeymapModes[], [2]: string, rhs: string|fun(), opts?: snacks.keymap.set.Opts }

---@class Keymaps
---@field protected keymaps Keymap[]
---@field protected opts snacks.keymap.set.Opts
---@field new fun(self: Keymaps, keymaps?: Keymap[]): Keymaps
---@field add fun(self: Keymaps, keymaps: Keymap )
---@field add_multiple fun(self: Keymaps, keymaps: Keymap[] )
---@field set_opts fun(self: Keymaps, opts: snacks.keymap.set.Opts)
---@field setup fun(self: Keymaps)
local Keymaps = { keymaps = {}, opts = {} }

function Keymaps:new(keymaps)
	local k = { keymaps = {}, opts = {} }
	setmetatable(k, { __index = self })
	self.__index = self

	if keymaps ~= nil then k:add_multiple(keymaps) end

	return k
end

function Keymaps:add(keymap) table.insert(self.keymaps, keymap) end
function Keymaps:add_multiple(keymaps)
	for _, keymap in pairs(keymaps) do
		self:add(keymap)
	end
end

function Keymaps:set_opts(opts) self.opts = opts end

function Keymaps:setup()
	for _, keymap in ipairs(self.keymaps) do
		local mode, lhs, rhs, opts = unpack(keymap)
		local ok = pcall(Snacks.keymap.set, mode, lhs, rhs, opts)
		if not ok then vim.notify(vim.inspect(keymap), nil, { title = "Error setting keymaps" }) end
	end
end

return Keymaps
