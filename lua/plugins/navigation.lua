local term = vim.trim((vim.env.TERM_PROGRAM or ""):lower())
local mux = term == "tmux" or term == "wezterm" or vim.env.KITTY_LISTEN_ON

---@type LazySpec
return {
	{
		"DrKJeff16/project.nvim",
		dependencies = { "folke/snacks.nvim", "mason-org/mason-lspconfig.nvim" },
		event = "User File",
		cmd = {
			"Project",
			"ProjectAdd",
			"ProjectConfig",
			"ProjectDelete",
			"ProjectExport",
			"ProjectHealth",
			"ProjectHistory",
			"ProjectImport",
			"ProjectLog",
			"ProjectRecents",
			"ProjectRoot",
			"ProjectSession",
			"ProjectSnacks",
		},
		---@module "project"
		---@type Project.Config.Options
		opts = {
			lsp = {
				enabled = true,
				ignore = { "tailwindcss" },
				use_pattern_matching = false,
				no_fallback = true,
			},
			scope_chdir = "win",
			snacks = { enabled = true },
			patterns = {
				".git",
				".github",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"Pipfile",
				"pyproject.toml",
				".pre-commit-config.yaml",
				".pre-commit-config.yml",
				".csproj",
				".sln",
				".nvim.lua",
				".neoconf.json",
				"neoconf.json",
				"Makefile",
				"Justfile",
				-- "package.json",
				-- "tsconfig.json",
				"go.mod",
				"go.sum",
				"Cargo.toml",
				"Cargo.lock",
			},
		},
	},
	{ "nvim-mini/mini.ai", event = "VeryLazy", opts = {} },
	{
		"nmac427/guess-indent.nvim",
		event = "User File",
		---@module "guess-indent"
		---@type GuessIndentConfig
		opts = { auto_cmd = true },
	},
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
				desc = "Previous start of camel case word",
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
		---@type VariousTextobjs.Config
		opts = { keymaps = { useDefaults = false } },
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
		event = "User File",
		cmd = { "TodoTrouble", "TodoTelescope", "TodoLocList", "TodoQuickFix" },
		keys = {
			---@diagnostic disable-next-line: undefined-field
			{ "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find TODO comments" },
		},
		opts = {},
	},
	{
		"hasansujon786/nvim-navbuddy",
		dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
		keys = {
			{ "<leader>fs", function() require("nvim-navbuddy").open() end, desc = "Breadcrumb search" },
		},
		---@type Navbuddy.config
		opts = {
			window = {
				border = vim.o.winborder --[[@as string]],
			},
			lsp = { auto_attach = true },
		},
		specs = { { "neovim/nvim-lspconfig", dependencies = { "hasansujon786/nvim-navbuddy" } } },
	},
	{
		"mrjones2014/smart-splits.nvim",
		event = mux and "VeryLazy" or nil, -- load early if mux detected
		keys = {
			{
				"<C-h>",
				function() require("smart-splits").move_cursor_left() end,
				desc = "Move focus to the left window/pane",
			},
			{
				"<C-j>",
				function() require("smart-splits").move_cursor_down() end,
				desc = "Move focus to the down window/pane",
			},
			{
				"<C-k>",
				function() require("smart-splits").move_cursor_up() end,
				desc = "Move focus to the up window/pane",
			},
			{
				"<C-l>",
				function() require("smart-splits").move_cursor_right() end,
				desc = "Move focus to the right window/pane",
			},
		},
		---@type SmartSplitsConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			ignored_filetypes = { "qf" },
			ignored_buftypes = { "nofile", "quickfix", "prompt" },
		},
	},
}
