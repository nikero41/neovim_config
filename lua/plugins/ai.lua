---@type LazySpec
return {
	{
		"supermaven-inc/supermaven-nvim",
		opts = { keymaps = { clear_suggestion = "<M-r>" } },
		specs = {
			{
				"AstroNvim/astrocore",
				opts = {
					options = {
						g = {
							-- set the ai_accept function
							ai_accept = function()
								local suggestion = require("supermaven-nvim.completion_preview")
								if suggestion.has_suggestion() then
									vim.schedule(function() suggestion.on_accept_suggestion() end)
									return true
								end
							end,
						},
					},
				},
			},
		},
	},
}
