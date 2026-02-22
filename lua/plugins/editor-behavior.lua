---@type LazySpec
return {
	{
		"okuuva/auto-save.nvim",
		keys = {
			{ "<leader>fa", "<CMD>ASToggle<CR>", desc = "Toggle auto-save" },
		},
		opts = {
			condition = function(buffer)
				local ok, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buffer })
				if ok and vim.list_contains({ "harpoon" }, filetype) then return false end
				return true
			end,
		},
		config = function(_, opts)
			require("auto-save").setup(opts)

			local group = vim.api.nvim_create_augroup("autosave", {})

			vim.api.nvim_create_autocmd("User", {
				pattern = "AutoSaveEnable",
				group = group,
				callback = function() vim.notify("AutoSave enabled", vim.log.levels.INFO) end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "AutoSaveDisable",
				group = group,
				callback = function() vim.notify("AutoSave disabled", vim.log.levels.INFO) end,
			})
		end,
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
		opts = { useDefaultKeymaps = false },
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
		"lewis6991/gitsigns.nvim",
		opts = function(_, opts)
			local original_on_attach = opts.on_attach
			opts.on_attach = function(bufnr)
				-- run default on_attach function
				if original_on_attach then original_on_attach(bufnr) end
				-- continue with customizations such as deleting mappings
				vim.keymap.del("n", "<Leader>gL", { buffer = bufnr })
			end
		end,
	},
	{
		"ray-x/sad.nvim",
		specs = {
			{
				"AstroNvim/astrocore",
				opts = {
					commands = {
						SearchAndReplace = {
							function(params)
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
							end,
							nargs = "?",
							desc = "Search and replace",
						},
					},
				},
			},
		},
	},
	{
		"gbprod/yanky.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = "VeryLazy",
		keys = {
			{
				"<leader>fy",
				function() Snacks.picker.yanky() end,
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
		},
		opts = {},
	},
	{
		"nvim-mini/mini.move",
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
}
