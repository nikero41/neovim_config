---@alias KeymapModes "n"|"i"|"v"|"x"|"o"|"c"|"t"|"s"|"l"
---@alias Keymap.Opts snacks.keymap.set.Opts | { optional?: boolean }

---@class KeymapInput
---@field [1] KeymapModes | KeymapModes[]
---@field [2] string
---@field [3] false | string | function
---@field [4] Keymap.Opts?
---
---@class Keymap
---@field modes KeymapModes[]
---@field lhs string
---@field rhs false | string | function
---@field opts Keymap.Opts

---@class Keymaps
---@field protected keymaps Keymap[]
---@field protected opts snacks.keymap.set.Opts
---@field new fun(self: Keymaps, keymaps?: KeymapInput[]): Keymaps
---@field add fun(self: Keymaps, keymaps: KeymapInput)
---@field add_multiple fun(self: Keymaps, keymaps: KeymapInput[])
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

function Keymaps:add(keymap)
	local modes = keymap[1]
	if type(modes) == "string" then modes = { modes } end
	table.insert(self.keymaps, {
		modes = modes,
		lhs = keymap[2],
		rhs = keymap[3],
		opts = keymap[4] or {},
	})
end

function Keymaps:add_multiple(keymaps)
	vim.iter(keymaps):each(function(keymap) self:add(keymap) end)
end

function Keymaps:set_opts(opts) self.opts = opts end

---@param keymap vim.api.keyset.get_keymap
local function from_nvim_keymap(keymap)
	---@type Keymap
	return {
		lhs = string.gsub(keymap.lhs, "^ ", "<leader>"),
		rhs = keymap.rhs,
		modes = { keymap.mode },
		opts = {
			desc = keymap.desc,
			buffer = keymap.buffer,
			silent = keymap.silent == 1 and true or false,
			expr = keymap.expr == 1 and true or false,
			noremap = keymap.noremap == 1 and true or false,
			script = keymap.script == 1 and true or false,
		},
	}
end

---@param seted_keymaps table<KeymapModes, Keymap[]>
---@param keymap Keymap
function Keymaps:apply(seted_keymaps, keymap)
	if keymap.rhs ~= false and keymap.opts.optional ~= false then
		keymap.modes = vim
			.iter(keymap.modes)
			:filter(function(mode)
				local existing_keymap = vim
					.iter(seted_keymaps[mode])
					:find(function(existing) return existing.lhs == keymap.lhs end) --[[@as Keymap|nil]]
				if existing_keymap == nil then return true end

				local are_the_same = keymap.opts.desc == existing_keymap.opts.desc
					and keymap.opts.buffer == existing_keymap.opts.buffer
				if are_the_same then return false end

				if keymap.opts.optional == nil then
					local message = ("`%s` already mapped: %s"):format(
						keymap.lhs,
						vim.inspect({ keymap = keymap, existing_keymap = existing_keymap })
					)
					vim.notify(message, vim.log.levels.WARN, { title = "Keymap conflict" })
				end
				return false
			end)
			:totable()
	end

	if #keymap.modes == 0 then return end

	if keymap.rhs == false then
		local ok, msg = pcall(Snacks.keymap.del, keymap.modes, keymap.lhs, keymap.opts)
		if not ok then
			vim.notify(
				msg .. ": " .. vim.inspect(keymap),
				vim.log.levels.ERROR,
				{ title = "Error deleting keymaps" }
			)
		end
	else
		local ok, msg = pcall(Snacks.keymap.set, keymap.modes, keymap.lhs, keymap.rhs, keymap.opts)
		if not ok then
			vim.notify(
				msg .. ": " .. vim.inspect(keymap),
				vim.log.levels.ERROR,
				{ title = "Error setting keymaps" }
			)
		end
	end
end

---@return table<KeymapModes, Keymap[]>
local function get_global_keymaps()
	---@type table<KeymapModes, Keymap[]>
	local modes = { n = {}, i = {}, v = {}, x = {}, o = {}, c = {}, t = {}, s = {}, l = {} }

	for mode in pairs(modes) do
		modes[mode] = vim.iter(vim.api.nvim_get_keymap(mode)):map(from_nvim_keymap):totable()
	end

	return modes
end

---@param buffer integer|boolean|nil
---@return table<KeymapModes, Keymap[]>
local function get_buffer_keymaps(buffer)
	---@type table<KeymapModes, Keymap[]>
	local modes = { n = {}, i = {}, v = {}, x = {}, o = {}, c = {}, t = {}, s = {}, l = {} }

	local bufnr = (buffer == true or buffer == 0) and vim.api.nvim_get_current_buf() or buffer
	if type(bufnr) ~= "number" then return modes end
	for mode in pairs(modes) do
		modes[mode] = vim.iter(vim.api.nvim_buf_get_keymap(bufnr, mode)):map(from_nvim_keymap):totable()
	end

	return modes
end

function Keymaps:setup()
	local global_keymaps = get_global_keymaps()

	vim
		.iter(self.keymaps)
		:map(vim.deepcopy)
		:map(function(keymap)
			local can_set_unique = keymap.opts.lsp == nil
				and keymap.opts.ft == nil
				and keymap.opts.buffer == nil
				and keymap.opts.optional == nil
			if keymap.opts.unique == nil and can_set_unique then keymap.opts.unique = true end
			return keymap
		end)
		:map(function(keymap)
			keymap.opts = vim.tbl_extend("force", self.opts, keymap.opts)
			return keymap
		end)
		:each(function(keymap)
			local seted_keymaps = global_keymaps

			if keymap.opts.buffer ~= nil then
				seted_keymaps = vim.deepcopy(global_keymaps)
				local buffer_keymaps = get_buffer_keymaps(keymap.opts.buffer)
				for mode in pairs(seted_keymaps) do
					vim.list_extend(seted_keymaps[mode], buffer_keymaps[mode])
				end
			end

			self:apply(seted_keymaps, keymap)
		end)
end

return Keymaps
