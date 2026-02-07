---@type LazySpec
return {
	{
		"folke/tokyonight.nvim",
		enabled = require("colorscheme") == "tokyonight",
		---@module "tokyonight"
		---@type tokyonight.Config
		---@diagnostic disable-next-line: missing-fields
		opts = {
			styles = {
				types = { bold = true },
				variables = { bold = true },
			},
		},
	},
	{ "rakr/vim-one", enabled = require("colorscheme") == "one" },
	{
		"sainnhe/sonokai",
		enabled = require("colorscheme") == "sonokai",
		init = function()
			vim.g.sonokai_style = "andromeda"
			vim.g.sonokai_enable_italic = 1
			vim.g.sonokai_dim_inactive_windows = 1
			vim.g.sonokai_spell_foreground = "colored"
			vim.g.sonokai_float_style = "dim"
			vim.g.sonokai_diagnostic_virtual_text = "colored"
			vim.g.sonokai_inlay_hints_background = "dimmed"
		end,
	},
	{
		"AstroNvim/astrotheme",
		enabled = require("colorscheme") == "astrodark",
		opts = {
			style = {
				transparent = true,
				inactive = false,
				simple_syntax_colors = false,
			},
		},
	},
	{
		"Shatur/neovim-ayu",
		enabled = require("colorscheme") == "ayu",
		opts = { mirage = false },
		config = function(_, opts) require("ayu").setup(opts) end,
	},
	{ "samharju/synthweave.nvim", enabled = require("colorscheme") == "synthweave" },
	{
		"navarasu/onedark.nvim",
		enabled = require("colorscheme") == "onedark",
		opts = {
			style = "darker",
			code_style = {
				variables = "bold",
				functions = "bold",
				comments = "italic",
				keywords = "italic",
			},
		},
	},
	{
		"olimorris/onedarkpro.nvim",
		enabled = require("colorscheme") == "onedark_vivid",
		opts = {
			styles = {
				types = "bold",
				methods = "bold",
				comments = "italic",
				keywords = "italic",
			},
			options = {
				cursorline = true,
				transparency = true,
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		---@module "catppuccin"
		---@type CatppuccinOptions
		---@diagnostic disable: missing-fields
		opts = { flavour = "mocha" },
	},
}
