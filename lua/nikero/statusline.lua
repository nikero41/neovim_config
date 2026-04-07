---@class StatusLine
---@field statusline_icon_hl fun(self: StatusLine, icon_hl: string, default_hl_token: string): string
local StatusLine = {}

function StatusLine:statusline_icon_hl(icon_hl, default_hl_token)
	local base_hl = default_hl_token:match("%%#(.-)#") or default_hl_token
	local group = ("Nikero_%s_%s"):format(base_hl, icon_hl):gsub("[^%w_]", "_")
	local icon = vim.api.nvim_get_hl(0, { name = group, link = false })

	if next(icon) ~= nil then return group end

	local base = vim.api.nvim_get_hl(0, { name = base_hl, link = false })
	local new_icon = vim.api.nvim_get_hl(0, { name = icon_hl, link = false })

	vim.api.nvim_set_hl(0, group, { fg = new_icon.fg, bg = base.bg })

	return group
end

function StatusLine:harpoon_item(default_hl, active_index)
	return function(index, item)
		local file_path = vim.fn.fnamemodify(item.value, ":p")
		local icon, base_icon_hl = require("mini.icons").get("file", file_path)

		local is_active = index == active_index
		local base_hl = default_hl
		if is_active then base_hl = "%#OverlayActive#" end

		local icon_hl = self:statusline_icon_hl(base_icon_hl, base_hl)
		local icon_str = self:wrap(icon_hl, icon) .. base_hl

		local value = string.format("%s %d", icon_str, index)

		if is_active then
			local side_hl = self:statusline_icon_hl("OverlayActiveInverted", default_hl)
			value = self:wrap(side_hl, "") .. value .. self:wrap(side_hl, "") .. default_hl
		else
			value = string.format(" %s ", value)
		end

		return value
	end
end

local MAX_DISPLAYED_WIDGETS = 3

function StatusLine:harpoon_widget(default_hl)
	local current_file = vim.fn.expand("%:p")
	local items = require("harpoon"):list().items

	local active_index = vim.iter(ipairs(items)):find(
		function(_, item) return vim.fn.fnamemodify(item.value, ":p") == current_file end
	)

	local start_index = 1
	if
		#items > MAX_DISPLAYED_WIDGETS
		and active_index ~= nil
		and active_index >= MAX_DISPLAYED_WIDGETS - 1
	then
		start_index = math.min(math.max(active_index - 1, 0), #items - MAX_DISPLAYED_WIDGETS + 1)
	end

	local widgets = vim
		.iter(ipairs(items))
		:skip(start_index - 1)
		:take(MAX_DISPLAYED_WIDGETS)
		:map(self:harpoon_item(default_hl, active_index))
		:join("")

	if start_index ~= 1 then widgets = string.gsub(widgets, "^%s", "<") end
	if start_index ~= #items - MAX_DISPLAYED_WIDGETS + 1 then
		widgets = string.gsub(widgets, "%s$", ">")
	end

	return widgets
end

function StatusLine:wrap(hl, text) return "%#" .. hl .. "#" .. text end

return StatusLine
