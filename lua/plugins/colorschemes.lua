local function set_colorscheme() vim.cmd.colorscheme(vim.g.colorscheme) end

---@type LazySpec
return {
	{
		"folke/tokyonight.nvim",
		enabled = vim.g.colorscheme == "tokyonight",
		---@module "tokyonight"
		---@type tokyonight.Config
		---@diagnostic disable-next-line: missing-fields
		opts = {
			styles = {
				types = { bold = true },
				variables = { bold = true },
			},
		},
		init = set_colorscheme,
	},
	{ "rakr/vim-one", enabled = vim.g.colorscheme == "one", init = set_colorscheme },
	{
		"sainnhe/sonokai",
		enabled = vim.g.colorscheme == "sonokai",
		init = function()
			vim.g.sonokai_style = "andromeda"
			vim.g.sonokai_enable_italic = 1
			vim.g.sonokai_dim_inactive_windows = 1
			vim.g.sonokai_spell_foreground = "colored"
			vim.g.sonokai_float_style = "dim"
			vim.g.sonokai_diagnostic_virtual_text = "colored"
			vim.g.sonokai_inlay_hints_background = "dimmed"

			set_colorscheme()
		end,
	},
	{
		"AstroNvim/astrotheme",
		enabled = vim.g.colorscheme == "astro",
		opts = {
			style = {
				transparent = true,
				inactive = false,
				simple_syntax_colors = false,
			},
		},
		init = set_colorscheme,
	},
	{
		"Shatur/neovim-ayu",
		enabled = vim.g.colorscheme == "ayu",
		opts = { mirage = false },
		config = function(_, opts) require("ayu").setup(opts) end,
		init = set_colorscheme,
	},
	{ "samharju/synthweave.nvim", enabled = vim.g.colorscheme == "synthweave", init = set_colorscheme },
	{
		"navarasu/onedark.nvim",
		enabled = vim.g.colorscheme == "onedark",
		opts = {
			style = "darker",
			code_style = {
				variables = "bold",
				functions = "bold",
				comments = "italic",
				keywords = "italic",
			},
		},
		init = set_colorscheme,
	},
	{
		"olimorris/onedarkpro.nvim",
		enabled = vim.g.colorscheme == "onedark_vivid",
		opts = {
			styles = {
				types = "bold",
				methods = "bold",
				comments = "italic",
				keywords = "italic",
			},
			options = {
				cursorline = true,
				transparency = false,
			},
		},
		init = set_colorscheme,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		---@module "catppuccin"
		---@type CatppuccinOptions
		---@diagnostic disable: missing-fields
		opts = {
			flavour = "mocha",
			auto_integrations = true,
			transparent_background = true,
		},
	},
}
