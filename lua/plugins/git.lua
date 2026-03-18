---@type LazySpec
return {
	{
		"lewis6991/gitsigns.nvim",
		event = "User File",
		opts = function()
			local keymaps = require("nikero.keymaps"):new({
				{
					"n",
					"<leader>gl",
					function() require("gitsigns").blame_line() end,
					{ desc = "View Git blame" },
				},
				{
					"n",
					"<leader>gp",
					function() require("gitsigns").preview_hunk_inline() end,
					{ desc = "Preview Git hunk" },
				},
				{
					"n",
					"<leader>gr",
					function() require("gitsigns").reset_hunk() end,
					{ desc = "Reset Git hunk" },
				},
				{
					"v",
					"<leader>gr",
					function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					{ desc = "Reset Git hunk" },
				},
				{
					"n",
					"<leader>gR",
					function() require("gitsigns").reset_buffer() end,
					{ desc = "Reset Git buffer" },
				},
				{
					"n",
					"<leader>gs",
					function() require("gitsigns").stage_hunk() end,
					{ desc = "Stage/Unstage Git hunk" },
				},
				{
					"v",
					"<leader>gs",
					function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
					{ desc = "Stage Git hunk" },
				},
				{
					"n",
					"<leader>gS",
					function() require("gitsigns").stage_buffer() end,
					{ desc = "Stage Git buffer" },
				},
				{
					"n",
					"<leader>gd",
					function() require("gitsigns").diffthis() end,
					{ desc = "View Git diff" },
				},

				{
					"n",
					"[G",
					function() require("gitsigns").nav_hunk("first") end,
					{ desc = "First Git hunk" },
				},
				{
					"n",
					"]G",
					function() require("gitsigns").nav_hunk("last") end,
					{ desc = "Last Git hunk" },
				},
				{
					"n",
					"]g",
					function() require("gitsigns").nav_hunk("next") end,
					{ desc = "Next Git hunk" },
				},
				{
					"n",
					"[g",
					function() require("gitsigns").nav_hunk("prev") end,
					{ desc = "Previous Git hunk" },
				},
				{ { "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inside Git hunk" } },
			})

			---@type Gitsigns.config
			return {
				signs = {
					add = { text = require("icons").GitSign },
					change = { text = require("icons").GitSign },
					delete = { text = require("icons").GitSignLine },
					topdelete = { text = require("icons").GitSignLine },
					changedelete = { text = require("icons").GitSign },
					untracked = { text = require("icons").GitSign },
				},
				signs_staged = {
					add = { text = require("icons").GitSign },
					change = { text = require("icons").GitSign },
					delete = { text = require("icons").GitSignLine },
					topdelete = { text = require("icons").GitSignLine },
					changedelete = { text = require("icons").GitSign },
				},
				on_attach = function(buffer)
					keymaps:set_opts({ buffer = buffer })
					keymaps:setup()
				end,
			}
		end,
	},
	{
		"FabijanZulj/blame.nvim",
		cmd = "BlameToggle",
		keys = { { "<Leader>gB", vim.cmd.BlameToggle, desc = "Toggle git blame" } },
		---@module "blame"
		---@type Config
		---@diagnostic disable-next-line: missing-fields
		opts = {
			date_format = "%d/%m/%Y",
			merge_consecutive = true,
		},
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		cmd = {
			"GitConflictChooseOurs",
			"GitConflictChooseTheirs",
			"GitConflictChooseBoth",
			"GitConflictChooseNone",
			"GitConflictNextConflict",
			"GitConflictPrevConflict",
			"GitConflictListQf",
		},
		---@module "git-conflict"
		---@type GitConflictUserConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			list_opener = "copen", -- TODO: use snacks.picker or trouble.nvim (?)
		},
	},
}
