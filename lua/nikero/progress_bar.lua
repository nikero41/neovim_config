---@class ProgressBar
---@field tasks table<string, { percentage?: number }>
---@field render_interval integer
---@field clear_delay integer
---@field render_scheduled boolean
---@field render_timer uv.uv_timer_t?
---@field clear_timer uv.uv_timer_t?
---@field last_state integer?
---@field last_percent integer?
local ProgressBar = {}
ProgressBar.__index = ProgressBar

local ESC = "\27"

---@enum con_emu_state
local con_emu_state = {
	clear = 0,
	progress = 1,
	error = 2,
	loading = 3,
	paused = 4,
}

---@param payload string
---@return string
local function osc(payload)
	local seq = ESC .. "]" .. payload .. ESC .. "\\"
	if vim.env.TMUX ~= nil then
		seq = seq:gsub(ESC, ESC .. ESC)
		return ESC .. "Ptmux;" .. seq .. ESC .. "\\"
	end
	return seq
end

---@param n number
---@param lo number
---@param hi number
---@return number
local function clamp(n, lo, hi)
	if n < lo then return lo end
	if n > hi then return hi end
	return n
end

---@param state con_emu_state
---@param percent integer|nil
---@return string
local function progress_osc(state, percent)
	if percent ~= nil then return osc(("9;4;%d;%d"):format(state, percent)) end
	return osc(("9;4;%d"):format(state))
end

---@param client_id integer|string
---@param token unknown
---@return string
local function task_key(client_id, token) return tostring(client_id) .. ":" .. tostring(token) end

---@param opts? { render_interval?: integer, clear_delay?: integer }
---@return ProgressBar
function ProgressBar.new(opts)
	opts = opts or {}
	return setmetatable({
		tasks = {},
		render_interval = opts.render_interval or 100,
		clear_delay = opts.clear_delay or 300,
		render_scheduled = false,
		render_timer = nil,
		clear_timer = nil,
		last_state = nil,
		last_percent = nil,
	}, ProgressBar)
end

---@param state con_emu_state
---@param percent number|nil
---@param force boolean|nil
function ProgressBar:_send(state, percent, force)
	if percent ~= nil then percent = math.floor(clamp(percent, 0, 100)) end
	if not force and self.last_state == state and self.last_percent == percent then return end

	local payload = progress_osc(state, percent)
	local ok = pcall(vim.api.nvim_ui_send, payload)
	if not ok then return end

	self.last_state = state
	self.last_percent = percent
end

function ProgressBar:_stop_clear_timer()
	if self.clear_timer then self.clear_timer:stop() end
end

function ProgressBar:_schedule_clear()
	self:_stop_clear_timer()
	if self.clear_timer == nil then self.clear_timer = vim.uv.new_timer() end
	self.clear_timer:start(
		self.clear_delay,
		0,
		vim.schedule_wrap(function()
			if next(self.tasks) ~= nil then return end
			self:_send(con_emu_state.clear, nil, true)
		end)
	)
end

function ProgressBar:_render_now()
	self:_stop_clear_timer()

	local count = 0
	local percent = nil
	for _, task in pairs(self.tasks) do
		count = count + 1
		if count == 1 then
			percent = task.percentage
		else
			percent = nil
			break
		end
	end

	if count == 0 then
		self:_schedule_clear()
	elseif percent ~= nil then
		self:_send(con_emu_state.progress, percent)
	else
		self:_send(con_emu_state.loading)
	end
end

function ProgressBar:_schedule_render()
	if self.render_scheduled then return end

	self.render_scheduled = true
	if self.render_timer == nil then self.render_timer = vim.uv.new_timer() end
	self.render_timer:start(
		self.render_interval,
		0,
		vim.schedule_wrap(function()
			self.render_scheduled = false
			self:_render_now()
		end)
	)
end

---@param args vim.api.keyset.create_autocmd.callback_args
function ProgressBar:on_lsp_progress(args)
	local data = args.data or {}
	local params = data.params or {}
	local value = params.value or {}
	local token = params.token
	if token == nil then return end

	local key = task_key(data.client_id or 0, token)
	if value.kind == "end" then
		self.tasks[key] = nil
	else
		self.tasks[key] = { percentage = value.percentage }
	end

	self:_schedule_render()
end

function ProgressBar:clear()
	self.tasks = {}
	self:_send(con_emu_state.clear, nil, true)
end

---@param self ProgressBar
function ProgressBar:destroy()
	if self.render_timer then
		self.render_timer:stop()
		self.render_timer:close()
		self.render_timer = nil
	end
	if self.clear_timer then
		self.clear_timer:stop()
		self.clear_timer:close()
		self.clear_timer = nil
	end
	self:clear()
end

local progress_bar = ProgressBar.new()

vim.api.nvim_create_autocmd("VimLeavePre", {
	desc = "Clear progress bar on exit",
	group = vim.api.nvim_create_augroup("clear-progress-bar", { clear = true }),
	callback = function() progress_bar:destroy() end,
})

return progress_bar
