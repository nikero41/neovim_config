---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		cmd = { "TSInstall", "TSInstallFromGrammar", "TSUpdate", "TSUninstall", "TSLog" },
		config = function()
			require("nvim-treesitter").install({
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

				-- Go
				"go",
				"gomod",
				"gosum",
				"gowork",

				"html",

				-- CSS
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

				-- JavaScript
				"javascript",
				"typescript",
				"tsx",
				"jsdoc",
				"svelte",
				"vue",

				"tmux",

				"xml",
				"yaml",

				-- Misc
				"diff",
				"luadoc",
				"query",
				"latex",
				"regex",
				"vim",
				"vimdoc",
			})

			vim.treesitter.language.register("bash", "dotenv")
			vim.treesitter.language.register("scss", "less")
			vim.treesitter.language.register("scss", "postcss")

			vim.api.nvim_create_autocmd("FileType", {
				desc = "Enable treesitter for supported files",
				group = vim.api.nvim_create_augroup("enable-treesitter", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang then return end

					local has_parser = pcall(vim.treesitter.get_parser, args.buf, lang)
					if not has_parser then return end

					vim.treesitter.start(args.buf, lang)
					if vim.bo[args.buf].buftype == "" then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
		init = function(plugin) require("lazy.core.loader").add_to_rtp(plugin) end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{
				"ak",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@block.outer",
						"textobjects"
					)
				end,
				desc = "around block",
				mode = { "x", "o" },
			},
			{
				"ik",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@block.inner",
						"textobjects"
					)
				end,
				desc = "inside block",
				mode = { "x", "o" },
			},
			{
				"ac",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@class.outer",
						"textobjects"
					)
				end,
				desc = "around class",
				mode = { "x", "o" },
			},
			{
				"ic",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@class.inner",
						"textobjects"
					)
				end,
				desc = "inside class",
				mode = { "x", "o" },
			},
			{
				"a?",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@conditional.outer",
						"textobjects"
					)
				end,
				desc = "around conditional",
				mode = { "x", "o" },
			},
			{
				"i?",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@conditional.inner",
						"textobjects"
					)
				end,
				desc = "inside conditional",
				mode = { "x", "o" },
			},
			{
				"af",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@function.outer",
						"textobjects"
					)
				end,
				desc = "around function",
				mode = { "x", "o" },
			},
			{
				"if",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@function.inner",
						"textobjects"
					)
				end,
				desc = "inside function",
				mode = { "x", "o" },
			},
			{
				"ao",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@loop.outer",
						"textobjects"
					)
				end,
				desc = "around loop",
				mode = { "x", "o" },
			},
			{
				"io",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@loop.inner",
						"textobjects"
					)
				end,
				desc = "inside loop",
				mode = { "x", "o" },
			},
			{
				"aa",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@parameter.outer",
						"textobjects"
					)
				end,
				desc = "around argument",
				mode = { "x", "o" },
			},
			{
				"ia",
				function()
					require("nvim-treesitter-textobjects.select").select_textobject(
						"@parameter.inner",
						"textobjects"
					)
				end,
				desc = "inside argument",
				mode = { "x", "o" },
			},

			{
				"]k",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start("@block.outer", "textobjects")
				end,
				desc = "Next block start",
				mode = { "n", "x", "o" },
			},
			{
				"]f",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@function.outer",
						"textobjects"
					)
				end,
				desc = "Next function start",
				mode = { "n", "x", "o" },
			},
			{
				"]a",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_start(
						"@parameter.inner",
						"textobjects"
					)
				end,
				desc = "Next argument start",
				mode = { "n", "x", "o" },
			},
			{
				"]K",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end("@block.outer", "textobjects")
				end,
				desc = "Next block end",
				mode = { "n", "x", "o" },
			},
			{
				"]F",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end(
						"@function.outer",
						"textobjects"
					)
				end,
				desc = "Next function end",
				mode = { "n", "x", "o" },
			},
			{
				"]A",
				function()
					require("nvim-treesitter-textobjects.move").goto_next_end(
						"@parameter.inner",
						"textobjects"
					)
				end,
				desc = "Next argument end",
				mode = { "n", "x", "o" },
			},
			{
				"[k",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@block.outer",
						"textobjects"
					)
				end,
				desc = "Previous block start",
				mode = { "n", "x", "o" },
			},
			{
				"[f",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@function.outer",
						"textobjects"
					)
				end,
				desc = "Previous function start",
				mode = { "n", "x", "o" },
			},
			{
				"[a",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_start(
						"@parameter.inner",
						"textobjects"
					)
				end,
				desc = "Previous argument start",
				mode = { "n", "x", "o" },
			},
			{
				"[K",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end(
						"@block.outer",
						"textobjects"
					)
				end,
				desc = "Previous block end",
				mode = { "n", "x", "o" },
			},
			{
				"[F",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end(
						"@function.outer",
						"textobjects"
					)
				end,
				desc = "Previous function end",
				mode = { "n", "x", "o" },
			},
			{
				"[A",
				function()
					require("nvim-treesitter-textobjects.move").goto_previous_end(
						"@parameter.inner",
						"textobjects"
					)
				end,
				desc = "Previous argument end",
				mode = { "n", "x", "o" },
			},

			{
				">K",
				function() require("nvim-treesitter-textobjects.swap").swap_next("@block.outer") end,
				desc = "Swap next block",
			},
			{
				">F",
				function() require("nvim-treesitter-textobjects.swap").swap_next("@function.outer") end,
				desc = "Swap next function",
			},
			{
				">A",
				function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,
				desc = "Swap next argument",
			},
			{
				"<K",
				function() require("nvim-treesitter-textobjects.swap").swap_previous("@block.outer") end,
				desc = "Swap previous block",
			},
			{
				"<F",
				function() require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer") end,
				desc = "Swap previous function",
			},
			{
				"<A",
				function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end,
				desc = "Swap previous argument",
			},
		},
		opts = {
			select = { lookahead = true },
			move = { set_jumps = true },
		},
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
		---@module "rainbow-delimiters"
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
			render = "virtual",
			enable_named_colors = true,
			enable_tailwind = true,
			virtual_symbol = "󱓻",
		},
		specs = {
			{
				"saghen/blink.cmp",
				---@module "blink.cmp"
				---@type blink.cmp.Config
				opts = {
					completion = {
						menu = {
							draw = {
								components = {
									kind_icon = {
										text = function(ctx)
											local icon = ctx.kind_icon
											if ctx.item.source_name == "LSP" then
												local color_item = require("nvim-highlight-colors").format(
													ctx.item.documentation,
													{ kind = ctx.kind }
												)
												if color_item and color_item.abbr ~= "" then icon = color_item.abbr end
											end
											return icon .. ctx.icon_gap
										end,
										highlight = function(ctx)
											local highlight = "BlinkCmpKind" .. ctx.kind
											if ctx.item.source_name == "LSP" then
												local color_item = require("nvim-highlight-colors").format(
													ctx.item.documentation,
													{ kind = ctx.kind }
												)
												if color_item and color_item.abbr_hl_group then
													highlight = color_item.abbr_hl_group
												end
											end
											return highlight
										end,
									},
								},
							},
						},
					},
				},
			},
		},
	},
	{
		"ghostty",
		event = { "BufRead */ghostty/config,*/ghostty/themes/*" },
		dir = vim.env.GHOSTTY_RESOURCES_DIR
				and vim.fs.joinpath(vim.env.GHOSTTY_RESOURCES_DIR, "..", "nvim", "site")
			or nil,
		cond = vim.env.GHOSTTY_RESOURCES_DIR ~= nil,
	},
	{ "fei6409/log-highlight.nvim", ft = "log", opts = {} },
	{
		"codethread/qmk.nvim",
		event = "BufRead *.keymap",
		---@module "qmk"
		---@type qmk.UserConfig
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
