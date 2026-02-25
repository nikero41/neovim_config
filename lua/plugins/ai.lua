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
		},
		specs = {
			{
				"saghen/blink.cmp",
				opts = {
					keymap = {
						["<Tab>"] = {
							"snippet_forward",
							function()
								local suggestion = require("supermaven-nvim.completion_preview")
								if suggestion.has_suggestion() then
									vim.schedule(function() suggestion.on_accept_suggestion() end)
									return true
								end
							end,
							"fallback",
						},
					},
				},
			},
		},
	},
	{
		"NickvanDyke/opencode.nvim",
		keys = {
			-- TODO:
			-- { "AstroNvim/astroui", opts = { icons = { OpenCode = "" } } },
			-- { "<leader>O", desc = require("astroui").get_icon("OpenCode", 1, true) .. "OpenCode" },
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
			{ "<leader>On", function() require("opencode").command("session.new") end, desc = "New session" },
			{
				"<leader>Os",
				function() require("opencode").select() end,
				desc = "Select prompt",
				mode = { "n", "v" },
			},
		},
		config = function(plugin)
			---@type opencode.Opts
			vim.g.opencode_opts = {
				provider = {
					enabled = "tmux",
					tmux = {},
				},
			}

			-- TODO:
			vim.api.nvim_create_autocmd("User", {
				pattern = "OpencodeEvent:*", -- Optionally filter event types
				callback = function(args)
					---@type opencode.cli.client.Event
					local event = args.data.event
					---@type number
					local port = args.data.port

					-- See the available event types and their properties
					vim.notify(vim.inspect(event))
					-- Do something useful
					if event.type == "session.idle" then vim.notify("`opencode` finished responding") end
				end,
			})
		end,
	},
}
