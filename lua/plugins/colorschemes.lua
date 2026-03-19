local function set_colorscheme() vim.cmd.colorscheme(vim.g.colorscheme) end

---@type LazySpec
return {
	{
		"folke/tokyonight.nvim",
		enabled = vim.g.colorscheme == "tokyonight",
		priority = 1000,
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
	{ "rakr/vim-one", enabled = vim.g.colorscheme == "one", priority = 1000, init = set_colorscheme },
	{
		"sainnhe/sonokai",
		enabled = vim.g.colorscheme == "sonokai",
		priority = 1000,
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
		priority = 1000,
		---@module "astrotheme"
		---@type AstroThemeOpts
		opts = {
			style = {
				transparent = require("nikero.config").transparency,
				simple_syntax_colors = false,
			},
		},
		init = set_colorscheme,
	},
	{
		"Shatur/neovim-ayu",
		main = "ayu",
		enabled = vim.g.colorscheme == "ayu",
		priority = 1000,
		opts = { mirage = false },
		init = set_colorscheme,
	},
	{
		"samharju/synthweave.nvim",
		enabled = vim.g.colorscheme == "synthweave",
		priority = 1000,
		init = set_colorscheme,
	},
	{
		"navarasu/onedark.nvim",
		enabled = vim.g.colorscheme == "onedark",
		priority = 1000,
		opts = {
			transparent = require("nikero.config").transparency,
			code_style = {
				variables = "bold",
				functions = "bold",
				comments = "italic",
				keywords = "italic",
			},
			lualine = { transparent = require("nikero.config").transparency },
		},
		config = function(_, opts)
			require("onedark").setup(opts)
			require("onedark").load()
		end,
		init = set_colorscheme,
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
		opts = {
			styles = {
				types = "bold",
				methods = "bold",
				comments = "italic",
				keywords = "italic",
			},
			options = {
				cursorline = true,
				transparency = require("nikero.config").transparency,
				highlight_inactive_windows = true,
			},
			plugins = {
				all = false,
				lsp_semantic_tokens = true,
				nvim_lsp = true,
				treesitter = true,
				gitsigns = true,
				neo_tree = true,
				rainbow_delimiters = true,
				render_markdown = true,
				which_key = true,
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		---@module "catppuccin"
		---@type CatppuccinOptions
		---@diagnostic disable: missing-fields
		opts = {
			flavour = "mocha",
			auto_integrations = true,
			integrations = {
				lualine = {
					all = function(colors)
						return {
							normal = {
								c = { bg = colors.base, fg = colors.text },
							},
							inactive = {
								a = { bg = colors.base, fg = colors.blue },
								b = { bg = colors.base, fg = colors.surface1, gui = "bold" },
								c = { bg = colors.base, fg = colors.overlay0 },
							},
						}
					end,
				},
			},
			transparent_background = require("nikero.config").transparency,
			highlight_overrides = {
				all = function() return require("highlights"):get() end,
			},
			dim_inactive = {
				enabled = true,
				percentage = 0.1,
			},
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = { "bold" },
				keywords = { "italic" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = { "bold" },
				operators = {},
			},
			lsp_styles = {
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
					ok = { "undercurl" },
				},
				inlay_hints = { background = false },
			},
		},
		init = set_colorscheme,
	},
}
