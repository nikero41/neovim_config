---@type LazySpec
return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "VeryLazy",
		opts = {
			keymaps = {
				accept_suggestion = "<M-r>",
				clear_suggestion = "<C-h>",
				accept_word = "<C-w>",
			},
			ignore_filetypes = {
				"neo-tree-popup",
				"DressingInput",
				"snacks_input",
			},
		},
		init = function()
			vim.g.ai_accept = function()
				local suggestion = require("supermaven-nvim.completion_preview")
				if suggestion.has_suggestion() then
					vim.schedule(function() suggestion.on_accept_suggestion() end)
					return true
				end
			end
		end,
	},
	{
		"NickvanDyke/opencode.nvim",
		keys = {
			{ "<leader>Ot", function() require("opencode").toggle() end, desc = "Toggle embedded" },
			{
				"<leader>Oa",
				function() require("opencode").ask("@this: ", { submit = true }) end,
				desc = "Ask about this",
				mode = { "n", "v" },
			},
			{
				"<leader>O+",
				function() require("opencode").prompt("@buffer", { append = true }) end,
				desc = "Add buffer to prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>Oe",
				function() require("opencode").prompt("Explain @this and its context", { submit = true }) end,
				desc = "Explain this code",
			},
			{
				"<leader>On",
				function() require("opencode").command("session.new") end,
				desc = "New session",
			},
			{
				"<leader>Os",
				function() require("opencode").select() end,
				desc = "Select prompt",
				mode = { "n", "v" },
			},
		},
		init = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				provider = {
					enabled = "tmux",
					tmux = {},
				},
			}
		end,
		specs = {
			{
				"folke/snacks.nvim",
				opts = {
					picker = {
						actions = {
							opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
						},
						win = { input = { keys = { ["<M-x>"] = { "opencode_send", mode = { "n", "i" } } } } },
					},
				},
			},
		},
	},
}
