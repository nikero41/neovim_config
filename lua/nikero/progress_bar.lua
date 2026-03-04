---@class ProgressBar
---@field loading fun(self: ProgressBar)
---@field error fun(self: ProgressBar, percent: number | nil)
---@field progress fun(self: ProgressBar, percent: number | nil)
---@field clear fun(self: ProgressBar)
local ProgressBar = {}

local ESC = "\27"

-- OSC ... ST  (ST can be ESC \)
---@param payload string
---@return string
local function osc(payload)
	local seq = ESC .. "]" .. payload .. ESC .. "\\"

	-- Wrap an escape sequence so tmux forwards it to the outer terminal.
	-- This requires tmux allow-passthrough on.
	if os.getenv("TMUX") ~= nil then
		-- Inside the DCS wrapper, tmux expects ESC bytes to be doubled.
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

---@enum con_emu_state
local con_emu_state = {
	clear = 0,
	progress = 1, -- normal
	error = 2,
	loading = 3, -- indeterminate
	paused = 4,
}

---@param state con_emu_state
---@param percent number|nil
---@return string
local function progress_osc(state, percent)
	if percent ~= nil then
		percent = math.floor(clamp(percent, 0, 100))
		return osc(("9;4;%d;%d"):format(state, percent))
	end
	return osc(("9;4;%d"):format(state))
end

---@param seq string
local function write_osc(seq)
	io.stdout:write(seq)
	io.stdout:flush()
end

function ProgressBar:loading() write_osc(progress_osc(con_emu_state.loading)) end
function ProgressBar:error(percent) write_osc(progress_osc(con_emu_state.error, percent)) end
function ProgressBar:progress(percent) write_osc(progress_osc(con_emu_state.progress, percent)) end
function ProgressBar:clear() write_osc(progress_osc(con_emu_state.clear)) end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function() ProgressBar:clear() end,
})

return ProgressBar
