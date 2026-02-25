---@type LazySpec
return {
	{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
	{ "nguyenvukhang/nvim-toggler", event = { "User AstroFile", "InsertEnter" }, opts = {} },
	{ "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = { map_cr = true },
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "User AstroFile" },
		opts = {},
		config = function(_, opts)
			require("nvim-ts-autotag").setup(opts)
			vim.api.nvim_create_autocmd("InsertCharPre", {
				callback = function()
					if vim.v.char ~= "/" then return end
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					local char = vim.api.nvim_get_current_line():sub(col, col)
					if char ~= "<" then return end
					vim.schedule(function() require("nikero.plugin_helpers"):auto_close_tag(row, col) end)
				end,
			})
		end,
	},
	{
		"ray-x/sad.nvim",
		dependencies = { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
		event = "User AstroFile",
		cmd = { "Sad" },
		opts = {},
		init = function()
			vim.api.nvim_create_user_command("SearchAndReplace", function(params)
				vim.ui.input({
					prompt = "Search",
					default = params.args[1] or vim.fn.expand("<cword>") or "",
				}, function(search_word)
					if search_word == nil then return end
					vim.ui.input({
						prompt = "Replace",
					}, function(replace_word)
						if replace_word == nil then return end
						vim.ui.input(
							{ prompt = "Filetype" },
							function(filetype) require("sad").Replace(search_word, replace_word, filetype) end
						)
					end)
				end)
			end, { nargs = "?", desc = "Search and replace" })
		end,
	},
	{
		"Wansmer/treesj",
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		keys = {
			{
				"<leader>m",
				function() require("treesj").toggle() end,
				desc = "Split/join block",
			},
			{
				"<leader>M",
				function() require("treesj").toggle({ split = { recursive = true } }) end,
				desc = "Split/join block recursively",
			},
		},
		opts = { use_default_keymaps = false },
	},
	{
		"chrisgrieser/nvim-chainsaw",
		keys = {
			{ "<leader>cv", function() require("chainsaw").variableLog() end, desc = "Log variable" },
			{ "<leader>co", function() require("chainsaw").objectLog() end, desc = "Log object" },
			{ "<leader>cm", function() require("chainsaw").messageLog() end, desc = "Log" },
			{ "<leader>cb", function() require("chainsaw").emojiLog() end, desc = "Log beep" },
			{ "<leader>cr", function() require("chainsaw").removeLogs() end, desc = "Clear logs" },
			{
				"<leader>cf",
				function()
					local marker = require("chainsaw.config.config").config.marker
					require("snacks").picker.grep_word({
						title = marker .. " log statements",
						cmd = "rg",
						args = { "--trim" },
						search = marker,
						regex = false,
						live = false,
					})
				end,
				desc = "Clear logs",
			},
		},
		opts = {
			logStatements = {
				objectLog = {
					go = { 'slog.Debug("{{marker}} {{filename}}", "{{var}}", {{var}})' },
					javascript = 'console.log("{{marker}} {{var}}:", JSON.stringify({{var}}, null, 2));',
				},
				variableLog = { go = { 'slog.Debug("{{marker}} {{filename}}", "{{var}}", {{var}})' } },
				messageLog = { go = { 'slog.Debug("{{marker}} {{insert}}")' } },
				emojiLog = { go = { 'slog.Debug("{{marker}} {{emoji}}")' } },
			},
		},
	},
}
