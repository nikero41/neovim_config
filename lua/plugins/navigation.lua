---@type LazySpec
return {
	{ "nvim-mini/mini.ai", event = "VeryLazy", opts = {} },
	{ "nmac427/guess-indent.nvim", opts = {} },
	{
		"nvim-mini/mini.move",
		keys = function(plugin)
			local mappings = plugin.opts.mappings
			return {
				{ mappings.line_left, desc = "Move line left" },
				{ mappings.line_right, desc = "Move line right" },
				{ mappings.line_down, desc = "Move line down" },
				{ mappings.line_up, desc = "Move line up" },
				{ mappings.left, desc = "Move selection left", mode = "v" },
				{ mappings.right, desc = "Move selection right", mode = "v" },
				{ mappings.down, desc = "Move selection down", mode = "v" },
				{ mappings.up, desc = "Move selection up", mode = "v" },
			}
		end,
		opts = {
			mappings = {
				left = "<C-M-h>",
				right = "<C-M-l>",
				down = "<C-M-j>",
				up = "<C-M-k>",
				line_left = "<C-M-h>",
				line_right = "<C-M-l>",
				line_down = "<C-M-j>",
				line_up = "<C-M-k>",
			},
		},
	},
	{
		"max397574/better-escape.nvim",
		event = "VeryLazy",
		opts = {
			timeout = 300,
			default_mappings = false,
			mappings = {
				i = { j = { k = "<Esc>", j = "<Esc>" } },
			},
		},
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"<leader>w",
				function() require("spider").motion("w") end,
				mode = { "n", "o", "x" },
				desc = "Next camel case word",
			},
			{
				"<leader>e",
				function() require("spider").motion("e") end,
				mode = { "n", "o", "x" },
				desc = "Next end of camel case word",
			},
			{
				"<leader>b",
				function() require("spider").motion("b") end,
				mode = { "n", "o", "x" },
				desc = "Next start of camel case word",
			},
			{
				"<leader>ge",
				function() require("spider").motion("ge") end,
				mode = { "n", "o", "x" },
				desc = "Previous end of camel case word",
			},
		},
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		opts = { keymaps = { useDefaults = false } },
		keys = {
			{
				"a<leader>w",
				function() require("various-textobjs").subword("outer") end,
				mode = { "o", "x" },
			},
			{
				"i<leader>w",
				function() require("various-textobjs").subword("inner") end,
				mode = { "o", "x" },
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
		event = "User AstroFile",
		-- 	event = "VimEnter",
		cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
		keys = { { "<Leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find themes" } },
		opts = {},
	},
	{
		"hasansujon786/nvim-navbuddy",
		dependencies = { { "SmiteshP/nvim-navic", otps = { highlight = true } }, "MunifTanjim/nui.nvim" },
		specs = { { "neovim/nvim-lspconfig", dependencies = { "hasansujon786/nvim-navbuddy" } } },
		keys = {
			{ "<leader>fs", function() require("nvim-navbuddy").open() end, desc = "Breadcrumb search" },
		},
		opts = {
			window = { border = vim.o.winborder },
			lsp = { auto_attach = true },
		},
	},
	{
		"alexghergh/nvim-tmux-navigation",
		lazy = false,
		opts = {
			disable_when_zoomed = true,
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
			},
		},
	},
}
