---@type LazySpec
return {
	{
		"okuuva/auto-save.nvim",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		keys = {
			{ "<leader>fa", vim.cmd.ASToggle, desc = "Toggle auto-save" },
		},
		opts = {
			condition = function(buffer)
				local ok, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buffer })
				return not ok or not vim.list_contains({ "harpoon" }, filetype)
			end,
		},
		init = function()
			local group = vim.api.nvim_create_augroup("autosave", {})

			local initial_run = true
			vim.api.nvim_create_autocmd("User", {
				pattern = "AutoSaveEnable",
				group = group,
				callback = function()
					if initial_run then
						initial_run = false
						return
					end
					vim.notify("AutoSave enabled", vim.log.levels.INFO)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "AutoSaveDisable",
				group = group,
				callback = function() vim.notify("AutoSave disabled", vim.log.levels.INFO) end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "User NikeroFile",
		cmd = { "TSContext" },
		opts = {
			mode = "topline",
			separator = "",
			max_lines = 8,
			trim_scope = "outer",
		},
	},
	{
		"kevinhwang91/nvim-hlslens",
		opts = {
			auto_enable = true,
			calm_down = true,
			nearest_only = true,
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		keys = {
			{ "<leader>Ss", function() require("persistence").load() end, desc = "Restore Session" },
			{ "<leader>SS", function() require("persistence").select() end, desc = "Select Session" },
			{ "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
			{ "<leader>Sd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
		},
		opts = {},
	},
}
