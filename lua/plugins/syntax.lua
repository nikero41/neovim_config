---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			install_dir = vim.fn.stdpath("data") .. "/site",
			ensure_installed = {
				"astro",
				"bash",

				-- go
				"go",
				"gomod",
				"gosum",
				"gowork",

				"html",

				-- css
				"css",
				"scss",
				"styled",

				"hyprlang",
				"json",

				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
		},
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			pcall(require, "nvim-treesitter.query_predicates")

			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
		config = function(plugin, opts)
			require("nvim-treesitter").install(opts.ensure_installed)

			vim.treesitter.language.register("bash", "dotenv")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = opts.ensure_installed,
				callback = function() vim.treesitter.start() end,
			})
		end,
	},
	{
		"laytan/cloak.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "CloakDisable", "CloakEnable", "CloakToggle" },
		opts = {},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		submodules = false,
		event = "User AstroFile",
		-- TODO:
		-- main = "rainbow-delimiters.setup",
		---@param opts rainbow_delimiters.config
		opts = function(_, opts)
			local js_query = "rainbow-parens"
			if opts.query == nil then opts.query = {} end
			for _, language in pairs(require("filetypes").javascript) do
				opts.query[language] = js_query
			end
			opts.query.tsx = js_query
			return opts
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		cmd = "RenderMarkdown",
		ft = function()
			local plugin = require("lazy.core.config").spec.plugins["render-markdown.nvim"]
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)
			return opts.file_types or { "markdown" }
		end,
		---@module "render-markdown"
		---@type render.md.UserConfig
		opts = {
			completions = { blink = { enabled = true } },
			heading = {
				render_modes = true,
				border = true,
				border_virtual = true,
			},
			paragraph = { render_modes = true },
			code = {
				render_modes = true,
				width = "block",
				left_pad = 2,
				right_pad = 2,
			},
			dash = { render_modes = true },
			bullet = { render_modes = true },
			checkbox = {
				render_modes = true,
				unchecked = { icon = "✘ " },
				checked = {
					icon = "✔ ",
					scope_highlight = "@markup.strikethrough",
				},
				custom = {
					todo = {
						rendered = "◯ ",
						scope_highlight = "@markup.strikethrough",
					},
				},
			},
			quote = { render_modes = true },
			pipe_table = { render_modes = true },
			link = { render_modes = true },
			indent = {
				enabled = true,
				render_modes = true,
				per_level = 2,
				skip_heading = true,
			},
			overrides = {
				buftype = {
					nofile = {
						heading = {
							border = false,
							backgrounds = { "Title" },
							foregrounds = { "Title" },
						},
						code = {
							style = "normal",
							disable_background = true,
							left_pad = 0,
						},
					},
				},
			},
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "User AstroFile", "InsertEnter" },
		cmd = { "HighlightColors" },
		opts = {
			enable_named_colors = true,
			enable_tailwind = true,
			virtual_symbol = "󱓻",
		},
	},
	{
		"ghostty",
		-- event = { "BuffRead */ghostty/config,*/ghostty/themes/*" },
		dir = vim.env.GHOSTTY_RESOURCES_DIR and vim.fs.joinpath(vim.env.GHOSTTY_RESOURCES_DIR, "..", "nvim", "site") or nil,
		lazy = false,
		cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil,
	},
}
