---@alias KeymapModes "n"|"i"|"v"|"x"|"o"|"c",
---@alias Keymap.Opts snacks.keymap.set.Opts | { optional?: boolean }

---@class Keymap
---@field [1] KeymapModes | KeymapModes[]
---@field [2] string
---@field [3] false | string | fun()
---@field [4] Keymap.Opts?

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
		local mode, lhs, rhs, opts = keymap[1], keymap[2], keymap[3], (keymap[4] or {})

		-- if opts.unique == nil then opts.unique = true end
		---@type Keymap.Opts
		opts = vim.tbl_extend("force", self.opts, opts)

		if rhs == false then
			local ok = pcall(Snacks.keymap.del, mode, lhs, opts)
			if not ok then vim.notify(vim.inspect(keymap), nil, { title = "Error deleting keymaps" }) end
		else
			local ok = pcall(Snacks.keymap.set, mode, lhs, rhs, opts)
			if not ok and not opts.optional then
				vim.notify(vim.inspect(keymap), nil, { title = "Error setting keymaps" })
			end
		end
	end
end

return Keymaps
