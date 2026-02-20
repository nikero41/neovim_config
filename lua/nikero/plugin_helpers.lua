---@class PluginHelpers
---@field auto_close_tag fun(self: PluginHelpers, row: integer, col: integer)
local PluginHelpers = {}

function PluginHelpers:auto_close_tag(row, col)
	-- move cursor to the beginning of the tag to simulate the behavior of the default behavior of the plugin
	vim.api.nvim_win_set_cursor(0, { row, col - 1 })
	require("nvim-ts-autotag.internal").close_slash_tag()
	-- add slash at the beginning of the tag
	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "/" })
	local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
	local next_col = new_col + 1
	-- move cursor to the end of the tag and remove initial slash
	vim.api.nvim_win_set_cursor(0, { new_row, next_col })
	vim.api.nvim_buf_set_text(0, new_row - 1, next_col, new_row - 1, next_col + 1, { "" })
end

return PluginHelpers
