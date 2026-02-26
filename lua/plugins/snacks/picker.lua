---@type LazySpec
return {
	"folke/snacks.nvim",
	keys = {
		{ "<Leader>f<CR>", function() require("snacks").picker.resume() end, desc = "Resume previous search" },
		{ "<Leader>f'", function() require("snacks").picker.marks() end, desc = "Find marks" },
		-- {
		-- 	"<Leader>fl",
		-- 	function() require("snacks").picker.lines() end,
		-- 	desc = "Find lines",
		-- },
		{
			"<Leader>fa",
			function() require("snacks").picker.files({ dirs = { vim.fn.stdpath("config") }, desc = "Config Files" }) end,
			desc = "Find AstroNvim config files",
		},
		{ "<Leader>fb", function() require("snacks").picker.buffers() end, desc = "Find buffers" },
		{ "<Leader>fc", function() require("snacks").picker.grep_word() end, desc = "Find word under cursor" },
		{ "<Leader>fC", function() require("snacks").picker.commands() end, desc = "Find commands" },
		{
			"<Leader>ff",
			function()
				require("snacks").picker.files({
					hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat(".git") or {}, "type") == "directory",
				})
			end,
			desc = "Find files",
		},
		{
			"<Leader>fF",
			function() require("snacks").picker.files({ hidden = true, ignored = true }) end,
			desc = "Find all files",
		},
		{ "<Leader>fg", function() require("snacks").picker.git_files() end, desc = "Find git files" },
		{ "<Leader>fk", function() require("snacks").picker.keymaps() end, desc = "Find keymaps" },
		{ "<Leader>fn", function() require("snacks").picker.notifications() end, desc = "Find notifications" },
		{ "<Leader>fo", function() require("snacks").picker.recent() end, desc = "Find old files" },
		{
			"<Leader>fO",
			function() require("snacks").picker.recent({ filter = { cwd = true } }) end,
			desc = "Find old files (cwd)",
		},
		{ "<Leader>fp", function() require("snacks").picker.projects() end, desc = "Find projects" },
		{ "<Leader>fr", function() require("snacks").picker.registers() end, desc = "Find registers" },
		{ "<Leader>fw", function() require("snacks").picker.grep() end, desc = "Find words" },
		{
			"<Leader>fW",
			function() require("snacks").picker.grep({ hidden = true, ignored = true }) end,
			desc = "Find words in all files",
		},
		{ "<Leader>fu", function() require("snacks").picker.undo() end, desc = "Find undo history" },
		{ "<Leader>lD", function() require("snacks").picker.diagnostics() end, desc = "Search diagnostics" },
	},
	---@type snacks.Config
	opts = {
		picker = {
			ui_select = true,
			matcher = {
				cwd_bonus = true,
				frecency = true,
			},
			previewers = { git = { native = true } },
			win = {
				input = {
					keys = {
						["<C-w>"] = { "cycle_win", mode = { "i", "n" } },
						["<C-x>"] = { "edit_split", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<C-w>"] = "cycle_win",
						["<C-x>"] = "edit_split",
					},
				},
				preview = {
					keys = {
						["<C-w>"] = "cycle_win",
					},
				},
			},
		},
	},
}
