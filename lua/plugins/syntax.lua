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
				"devicetree",

				-- Go
				"go",
				"gomod",
				"gosum",
				"gowork",
				"templ",

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

					local parser = vim.treesitter.get_parser(args.buf, lang)
					if not parser then return end

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
		keys = function()
			local config = {
				select = {
					select_textobject = {
						["ak"] = { query = "@block.outer", desc = "around block" },
						["ik"] = { query = "@block.inner", desc = "inside block" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "inside class" },
						["a?"] = { query = "@conditional.outer", desc = "around conditional" },
						["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
						["af"] = { query = "@function.outer", desc = "around function" },
						["if"] = { query = "@function.inner", desc = "inside function" },
						["ao"] = { query = "@loop.outer", desc = "around loop" },
						["io"] = { query = "@loop.inner", desc = "inside loop" },
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "inside argument" },
					},
				},
				move = {
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
			}

			local keys = {}
			for module, methods in pairs(config) do
				for method, textobjects in pairs(methods) do
					for key, textobject in pairs(textobjects) do
						table.insert(keys, {
							key,
							function()
								require("nvim-treesitter-textobjects" .. module)[method](
									textobject.query("textobjects")
								)
							end,
							desc = textobject.desc,
							mode = module == "select" and { "x", "o" } or { "n", "x", "o" },
						})
					end
				end
			end

			return keys
		end,
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
			vim
				.iter(require("filetypes").javascript)
				:each(function(language) opts.query[language] = js_query end)
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
			file_types = { "markdown", "md", "AgenticChat" },
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
