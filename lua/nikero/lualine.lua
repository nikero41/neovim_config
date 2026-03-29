---@class Lualine
---@field statusline_icon_hl fun(self: Lualine, icon_hl: string, default_hl_token: string): string
local Lualine = {}

function Lualine:statusline_icon_hl(icon_hl, default_hl_token)
	local base_hl = default_hl_token:match("%%#(.-)#") or "StatusLine"
	local group = ("LualineIcon_%s_%s"):format(base_hl, icon_hl):gsub("[^%w_]", "_")
	local icon = vim.api.nvim_get_hl(0, { name = group, link = false })

	if next(icon) then return group end

	local base = vim.api.nvim_get_hl(0, { name = base_hl, link = false })
	local new_icon = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })

	vim.api.nvim_set_hl(0, group, { fg = new_icon.fg, bg = base.bg })

	return group
end

return Lualine
