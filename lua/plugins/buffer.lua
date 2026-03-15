---@type LazySpec
return {
	{
		"okuuva/auto-save.nvim",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		keys = {
			{ "<leader>fa", vim.cmd.ASToggle, desc = "Toggle auto-save" },
		},
		---@module "auto-save"
		---@type Config
		opts = {
			condition = function(buffer)
				if vim.fn.getbufvar(buffer, "&buftype") ~= "" then return false end

				local excluded_filetypes = {
					"harpoon",
					"gitcommit",
					"neo-tree",
					"neo-tree-popup",
					"TelescopePrompt",
					"lazy",
					"mason",
					"oil",
					"snacks_dashboard",
				}

				return not vim.tbl_contains(excluded_filetypes, vim.bo[buffer].filetype)
			end,
		},
		init = function()
			local group = vim.api.nvim_create_augroup("autosave", { clear = true })

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
		event = "User File",
		cmd = { "TSContext" },
		---@module "treesitter-context"
		---@type TSContext.UserConfig
		opts = { multiwindow = true, mode = "topline" },
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
			{
				"<leader>Sl",
				function() require("persistence").load({ last = true }) end,
				desc = "Restore Last Session",
			},
			{
				"<leader>Sd",
				function() require("persistence").stop() end,
				desc = "Don't Save Current Session",
			},
		},
		opts = {},
	},
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		---@module "origami"
		---@type Origami.config
		opts = { autoFold = { enabled = false } },
	},
}
