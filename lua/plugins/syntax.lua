---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		lazy = vim.fn.argc(-1) == 0, -- load treesitter immediately when opening a file from the cmdline
		event = "VeryLazy",
		main = "nvim-treesitter.configs",
		cmd = {
			"TSBufDisable",
			"TSBufEnable",
			"TSBufToggle",
			"TSDisable",
			"TSEnable",
			"TSToggle",
			"TSInstall",
			"TSInstallInfo",
			"TSInstallSync",
			"TSModuleInfo",
			"TSUninstall",
			"TSUpdate",
			"TSUpdateSync",
		},
		build = ":TSUpdate",
		opts = {
			indent = { enable = true },
			highlight = { enable = true },
			folds = { enable = true },
			incremental_selection = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["ak"] = { query = "@block.outer", desc = "around block" },
						["ik"] = { query = "@block.inner", desc = "inside block" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inside class" },
						["a?"] = { query = "@conditional.outer", desc = "around conditional" },
						["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
						["af"] = { query = "@function.outer", desc = "around function " },
						["if"] = { query = "@function.inner", desc = "inside function " },
						["ao"] = { query = "@loop.outer", desc = "around loop" },
						["io"] = { query = "@loop.inner", desc = "inside loop" },
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "inside argument" },
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]k"] = { query = "@block.outer", desc = "Next block start" },
						["]f"] = { query = "@function.outer", desc = "Next function start" },
						["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
					},
					goto_next_end = {
						["]K"] = { query = "@block.outer", desc = "Next block end" },
						["]F"] = { query = "@function.outer", desc = "Next function end" },
						["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
					},
					goto_previous_start = {
						["[k"] = { query = "@block.outer", desc = "Previous block start" },
						["[f"] = { query = "@function.outer", desc = "Previous function start" },
						["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
					},
					goto_previous_end = {
						["[K"] = { query = "@block.outer", desc = "Previous block end" },
						["[F"] = { query = "@function.outer", desc = "Previous function end" },
						["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						[">K"] = { query = "@block.outer", desc = "Swap next block" },
						[">F"] = { query = "@function.outer", desc = "Swap next function" },
						[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
					},
					swap_previous = {
						["<K"] = { query = "@block.outer", desc = "Swap previous block" },
						["<F"] = { query = "@function.outer", desc = "Swap previous function" },
						["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
					},
				},
			},
			ensure_installed = {
				"astro",
				"bash",

				-- C
				"cpp",
				"c",
				"objc",
				"cuda",
				"proto",

				"c_sharp",

				"dockerfile",

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
				"just",

				-- Lua
				"lua",
				"luap",

				-- Markdown
				"markdown",
				"markdown_inline",

				"nginx",
				"prisma",
				"python",
				"rust",
				"sql",
				"swift",
				"toml",

				-- Javascript
				"javascript",
				"typescript",
				"tsx",
				"jsdoc",

				"xml",
				"yaml",

				-- vim
				-- "diff",
				-- "luadoc",
				-- "query",
				"vim",
				"vimdoc",
				"regex",
			},
		},
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			pcall(require, "nvim-treesitter.query_predicates")
		end,
		config = function(_, opts)
			local ts = require("nvim-treesitter")
			ts.install(opts.ensure_installed)

			vim.treesitter.language.register("bash", "dotenv")
			vim.treesitter.language.register("scss", "less")
			vim.treesitter.language.register("scss", "postcss")

			local installed_parsers = ts.get_installed()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if vim.tbl_contains(installed_parsers, lang) then vim.treesitter.start(args.buf, lang) end
				end,
			})

			ts.setup(opts)
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
		event = "User File",
		main = "rainbow-delimiters.setup",
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
		event = { "User File", "InsertEnter" },
		cmd = { "HighlightColors" },
		opts = {
			enable_named_colors = true,
			enable_tailwind = true,
			virtual_symbol = "󱓻",
		},
	},
	{
		"ghostty",
		event = { "BufRead */ghostty/config,*/ghostty/themes/*" },
		dir = vim.env.GHOSTTY_RESOURCES_DIR and vim.fs.joinpath(vim.env.GHOSTTY_RESOURCES_DIR, "..", "nvim", "site") or nil,
		cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil,
	},
	{
		"codethread/qmk.nvim",
		event = "BufRead *.keymap",
		opts = {
			name = "corne",
			variant = "zmk",
			layout = {
				"x x x x x x _ x x x x x x",
				"x x x x x x _ x x x x x x",
				"x x x x x x _ x x x x x x",
				"_ _ _ x x x _ x x x _ _ _",
			},
		},
	},
}
