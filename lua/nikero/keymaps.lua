---@alias KeymapModes "n"|"i"|"v"|"x"|"o"|"c",
---@alias Keymap { modes: KeymapModes | KeymapModes[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts }

---@class Keymaps
---@field keymaps Keymap[]
---@field opts vim.keymap.set.Opts
---@field new fun(self: Keymaps, keymaps?: Keymap[]): Keymaps
---@field add fun(self: Keymaps, keymaps: Keymap )
---@field add_multiple fun(self: Keymaps, keymaps: Keymap[] )
---@field set_opts fun(self: Keymaps, opts: vim.keymap.set.Opts)
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
		opts = vim.tbl_deep_extend("force", self.opts, opts or {})
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

return Keymaps
