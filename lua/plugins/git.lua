---@type LazySpec
return {
	{
		"lewis6991/gitsigns.nvim",
		event = "User File",
		opts = function()
			local keymaps = require("nikero.keymaps"):new({
				{
					"n",
					"<leader>gB",
					function() require("gitsigns").blame() end,
					{ desc = "Git blame" },
				},
				{
					"n",
					"<leader>gl",
					function() require("gitsigns").blame_line() end,
					{ desc = "Git blame current line" },
				},
				{
					"n",
					"<leader>gp",
					function() require("gitsigns").preview_hunk() end,
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
				{ { "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "inside Git hunk" } },
			})

			---@type Gitsigns.config
			return {
				signs = {
					add = { text = require("icons").git.sign },
					change = { text = require("icons").git.sign },
					delete = { text = require("icons").git.sign_line },
					topdelete = { text = require("icons").git.sign_line },
					changedelete = { text = require("icons").git.sign },
					untracked = { text = require("icons").git.sign },
				},
				signs_staged = {
					add = { text = require("icons").git.sign },
					change = { text = require("icons").git.sign },
					delete = { text = require("icons").git.sign_line },
					topdelete = { text = require("icons").git.sign_line },
					changedelete = { text = require("icons").git.sign },
				},
				numhl = true,
				on_attach = function(buffer) keymaps:setup({ buf = buffer }) end,
			}
		end,
		init = function()
			require("snacks").toggle
				.new({
					name = "Git Word Diff",
					get = function() return require("gitsigns.config").config.word_diff end,
					set = function(state) require("gitsigns").toggle_word_diff(state) end,
				})
				:map("<leader>gw")
		end,
	},
	{
		"esmuellert/codediff.nvim",
		cmd = { "CodeDiff" },
		opts = {
			explorer = {
				icons = {
					folder_closed = require("icons").folders.closed,
					folder_open = require("icons").folders.open,
				},
				focus_on_select = true,
			},
		},
	},
}
