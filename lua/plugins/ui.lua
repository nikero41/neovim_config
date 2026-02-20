---@type LazySpec
return {
	{
		"folke/which-key.nvim",
		---@module "which-key"
		---@type wk.Opts
		opts = {
			preset = "modern",
			---@type wk.Win.opts
			win = { border = "none" },
		},
	},
	{
		"akinsho/toggleterm.nvim",
		opts = {
			float_opts = { border = require("utils.constants").border_type },
		},
	},
	{
		"FabijanZulj/blame.nvim",
		opts = { date_format = "%d/%m/%Y" },
	},
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>uu",
				"<CMD>UndotreeToggle<CR><CMD>UndotreeFocus<CR>",
				desc = "Toggle undotree",
			},
		},
		init = function() vim.g.undotree_WindowLayout = 2 end,
	},
	{
		"sindrets/diffview.nvim",
		opts = { view = { merge_tool = { layout = "diff4_mixed" } } },
	},
	{
		"kevinhwang91/nvim-bqf",
		dependencies = { "folke/snacks.nvim" },
		opts = function(_, opts)
			if not opts.preview then opts.preview = {} end
			if Snacks.util.is_transparent() then opts.preview.winblend = 0 end
			return opts
		end,
	},
	{
		"folke/noice.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = function(_, opts)
			return require("astrocore").extend_tbl(
				opts,
				---@module "noice"
				---@type NoiceConfig
				{
					notify = { enabled = false },
					lsp = {
						signature = { enabled = true },
						hover = { enabled = false },
						override = {
							["vim.lsp.util.convert_input_to_markdown_lines"] = false,
							["vim.lsp.util.stylize_markdown"] = false,
							["cmp.entry.get_documentation"] = false,
						},
					},
					views = {
						cmdline_popup = {
							border = Snacks.util.is_transparent() and {} or {
								style = "none",
								padding = { 1, 2 },
							},
						},
					},
					---@type NoicePresets
					presets = {
						bottom_search = false,
						command_palette = false,
						inc_rename = false,
						long_message_to_split = true,
					},
				}
			)
		end,
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = require("utils.constants").filetype.javascript,
		opts = { keymaps = { toggle = "gL" } },
	},
}
