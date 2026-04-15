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
				"bigfile",
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
				"<leader>ap",
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
		"ThePrimeagen/99",
		keys = {
			{ "<leader>as", function() require("99").search({}) end, desc = "Search" },
			{
				"<leader>ax",
				function() require("99").stop_all_requests() end,
				desc = "Stop all requests",
			},
			{ "<leader>ai", function() require("99").visual({}) end, desc = "Visual", mode = "v" },
		},
		opts = {
			model = "opencode/gpt-5.4",
			completion = { source = "blink" },
		},
	},
}
