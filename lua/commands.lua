---@class Commands
---@field setup fun(self: Commands)
local Commands = {}

function Commands:setup()
	vim.api.nvim_create_user_command(
		"CommandPalette",
		function() require("nikero.command_palette"):show() end,
		{ desc = "Command Palette" }
	)
end

return Commands
