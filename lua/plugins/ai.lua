---@type LazySpec
return {
	{
		"carlos-algms/agentic.nvim",
		dependencies = {
			{ "hakonharnes/img-clip.nvim", opts = {} },
		},
		keys = {
			{
				"<leader>ac",
				function() require("agentic").toggle() end,
				mode = { "n", "v" },
				desc = "Toggle Agentic Chat",
			},
			{
				"<leader>aB",
				function() require("agentic").add_selection_or_file_to_context() end,
				mode = { "n", "v" },
				desc = "Add file or selection to Agentic to Context",
			},
			{
				"<leader>an",
				function() require("agentic").new_session() end,
				mode = { "n", "v" },
				ft = { "AgenticChat", "AgenticFiles", "AgenticInput" },
				desc = "New Agentic Session",
			},
			{
				"<leader>ar",
				function() require("agentic").restore_session() end,
				ft = { "AgenticChat", "AgenticFiles", "AgenticInput" },
				mode = { "n", "v" },
				desc = "Agentic Restore session",
				silent = true,
			},
			{
				"<leader>ad",
				function() require("agentic").add_current_line_diagnostics() end,
				desc = "Add current line diagnostic to Agentic",
			},
			{
				"<leader>aD",
				function() require("agentic").add_buffer_diagnostics() end,
				desc = "Add all buffer diagnostics to Agentic",
			},
		},
		--- @type agentic.PartialUserConfig
		opts = {
			provider = "opencode-acp",
			headers = {},
		},
	},
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		opts = {
			log_level = "off",
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
				"neo-tree",
				"noice",
				"qf",
				"help",
				"snacks_dashboard",
				"AgenticChat",
				"AgenticInput",
				"AgenticFiles",
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
				function() require("opencode").ask("@this: ") end,
				desc = "Ask about this",
				mode = { "n", "v" },
			},
			{
				"go",
				function() return require("opencode").operator("@this") end,
				desc = "Send range to OpenCode",
				expr = true,
				mode = { "n", "x" },
			},
			{
				"goo",
				function() return require("opencode").operator("@this") .. "_" end,
				desc = "Send line to OpenCode",
				expr = true,
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
							---@module "snacks.picker"
							---@param picker snacks.Picker
							opencode_send = function(picker)
								local prompt = vim
									.iter(picker:selected({ fallback = true }))
									:map(
										---@param item snacks.picker.Item
										function(item)
											return item.file
													and require("opencode").format({
														path = item.file,
														from = item.pos,
														to = item.end_pos,
													})
												or item.text
										end
									)
									:join(", ")

								require("opencode").prompt(prompt .. " ")
							end,
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
