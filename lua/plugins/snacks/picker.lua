---@type LazySpec
return {
	"folke/snacks.nvim",
	keys = {
		{ "<Leader>f<CR>", function() require("snacks").picker.resume() end, desc = "Resume previous search" },
		{ "<Leader>f'", function() require("snacks").picker.marks() end, desc = "Find marks" },
		{ "<Leader>fb", function() require("snacks").picker.buffers() end, desc = "Find buffers" },
		{ "<Leader>fc", function() require("snacks").picker.grep_word() end, desc = "Find word under cursor" },
		{ "<Leader>fC", function() require("snacks").picker.commands() end, desc = "Find commands" },
		{
			"<Leader>ff",
			function()
				require("snacks").picker.files({
					hidden = vim.tbl_get(vim.uv.fs_stat(".git") or {}, "type") == "directory",
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

		-- LSP
		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
		{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "LSP Incoming Calls" },
		{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "LSP Outgoing Calls" },
		{ "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
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
