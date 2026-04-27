---@type LazySpec
return {
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		---@module "nvim-surround"
		---@type user_options
		opts = {},
	},
	{
		"nguyenvukhang/nvim-toggler",
		keys = { { "<leader>i", desc = "Toggle word", mode = { "n", "v" } } },
		opts = {},
	},
	{ "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			map_cr = false,
			check_ts = true,
		},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "User File",
		opts = {},
		config = function(_, opts)
			require("nvim-ts-autotag").setup(opts)
			vim.api.nvim_create_autocmd("InsertCharPre", {
				desc = "Auto close tag",
				group = vim.api.nvim_create_augroup("auto-close-tag", { clear = true }),
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
		dependencies = { { "ray-x/guihua.lua", build = "cd lua/fzy && make" } },
		event = "User File",
		cmd = { "Sad" },
		opts = {},
		init = function()
			vim.api.nvim_create_user_command("SearchAndReplace", function(params)
				vim.ui.input({
					prompt = "Search",
					default = params.args ~= "" and params.args or vim.fn.expand("<cword>"),
				}, function(search_word)
					if search_word == nil then return end
					vim.ui.input({ prompt = "Replace" }, function(replace_word)
						if replace_word == nil then return end
						vim.ui.input({ prompt = "Filetype" }, function(filetype)
							if filetype == nil then return end
							require("sad").Replace(search_word, replace_word, filetype)
						end)
					end)
				end)
			end, { nargs = "?", desc = "Search and replace" })
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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
				desc = "Find logs",
			},
		},
		---@type Chainsaw.config
		opts = {
			logStatements = {
				objectLog = {
					go = { 'slog.Debug("{{marker}} {{filename}}", "{{var}}", {{var}})' },
					javascript = 'console.log("{{marker}} {{var}}:", JSON.stringify({{var}}, null, 2));',
					typescript = 'console.log("{{marker}} {{var}}:", JSON.stringify({{var}}, null, 2));',
					typescriptreact = 'console.log("{{marker}} {{var}}:", JSON.stringify({{var}}, null, 2));',
					nvim_lua = "Chainsaw({{var}}) -- {{marker}}",
					rust = 'println!("{{marker}} {{var}}: {:?}", {{var}});',
				},
				variableLog = {
					go = { 'slog.Debug("{{marker}} {{filename}}", "{{var}}", {{var}})' },
					rust = 'println!("{{marker}} {{var}}: {:?}", {{var}});',
				},
				messageLog = {
					go = { 'slog.Debug("{{marker}} {{insert}}")' },
					rust = 'println!("{{marker}} {{insert}}");',
				},
				emojiLog = {
					go = { 'slog.Debug("{{marker}} {{emoji}}")' },
					rust = 'println!("{{marker}} {{emoji}}");',
				},
				assertLog = {
					rust = 'assert!({{var}}, "{{marker}} {{var}} {{insert}}");',
				},
				stacktraceLog = {
					rust = 'println!("{{marker}} stacktrace: {}", std::backtrace::Backtrace::force_capture());',
				},
				timeLogStop = {
					rust = 'println!("{{marker}} #{{index}}: {}", timelog_start_{{index}}.elapsed().as_millis());',
				},
			},
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			_G.Chainsaw = function(name)
				require("chainsaw")
				Chainsaw(name)
			end
		end,
	},
}
