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
			{
				"<leader>aa",
				function() require("opencode").ask("@this: ", { submit = true }) end,
				desc = "Ask about this",
				mode = { "n", "v" },
			},
			{
				"<leader>ab",
				function() require("opencode").prompt("@buffer", { append = true }) end,
				desc = "Add buffer to prompt",
				mode = { "n", "v" },
			},
			{
				"<leader>ae",
				function() require("opencode").prompt("Explain @this and its context", { submit = true }) end,
				desc = "Explain this code",
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
			vim.g.opencode_opts = {}
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
	{
		"piersolenski/wtf.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "folke/snacks.nvim" },
		cmd = { "Wtf", "WtfFix", "WtfPickProvider", "WtfSearch", "WtfHistory", "WtfGrepHistory" },
		keys = {
			{
				"<leader>ad",
				function() require("wtf").diagnose() end,
				desc = "Debug diagnostic with AI",
				mode = { "n", "x" },
			},
			{
				"<leader>af",
				function() require("wtf").fix() end,
				desc = "Fix diagnostic with AI",
				mode = { "n", "x" },
			},
			{
				"<leader>as",
				function() require("wtf").search() end,
				desc = "Search diagnostic with Google",
			},
			{
				"<leader>ap",
				function() require("wtf").pick_provider() end,
				desc = "Pick provider",
			},
			{
				"<leader>ah",
				function() require("wtf").history() end,
				desc = "Populate the quickfix list with previous chat history",
			},
			{
				"<leader>ag",
				function() require("wtf").grep_history() end,
				desc = "Grep previous chat history",
			},
		},
		opts = {
			popup_type = "popup",
			provider = "copilot",
			picker = "snacks",
		},
	},
}
