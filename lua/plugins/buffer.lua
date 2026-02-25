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
				if ok and vim.list_contains({ "harpoon" }, filetype) then return false end
				return true
			end,
		},
		init = function()
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
		"nvim-treesitter/nvim-treesitter-context",
		event = "User AstroFile",
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
}
