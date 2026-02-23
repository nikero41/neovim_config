---@class UiKeymaps
---@field configure fun(self: UiKeymaps, maps: Keymaps): nil
local UiKeymaps = {}

function UiKeymaps:configure(maps)
	maps:add("n", "gr", {
		function() Snacks.picker.lsp_references() end,
		desc = "Go to reference",
	})
	maps:add("n", "<Leader>P", { "<CMD>CommandPalette<CR>", desc = "Command Palette" })
end

return UiKeymaps
