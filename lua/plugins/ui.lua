---@module "nui.tree"

---@type LazySpec
return {
	{
		"nvim-mini/mini.icons",
		opts = function(_, opts)
			opts = opts or {}

			opts.file = vim.tbl_deep_extend("force", opts.file or {}, {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
				[".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
				[".nvmrc"] = { glyph = "", hl = "MiniIconsGreen" },
				[".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
				["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
				["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
				["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
				["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
			})

			opts.filetype = vim.tbl_deep_extend("force", opts.filetype or {}, {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
				gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
				postcss = { glyph = "󰌜", hl = "MiniIconsOrange" },
			})

			local filetypes = require("filetypes")

			for _, filename in ipairs(filetypes.prettier_config) do
				opts.file[filename] = { glyph = "", hl = "MiniIconsPurple" }
			end

			for _, filename in ipairs(filetypes.eslint_config) do
				opts.file[filename] = { glyph = "󰱺", hl = "MiniIconsYellow" }
			end

			return opts
		end,
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		specs = {
			{
				"nvim-neo-tree/neo-tree.nvim",
				---@module "neo-tree"
				---@type neotree.Config
				opts = {
					default_component_configs = {
						---@diagnostic disable-next-line: missing-fields
						icon = {
							provider = function(icon, node)
								local text, hl
								local mini_icons = require("mini.icons")
								if node.type == "file" then
									text, hl = mini_icons.get("file", node.name)
								elseif node.type == "directory" then
									text, hl = mini_icons.get("directory", node.name)
									if node:is_expanded() then text = nil end
								end

								if text then icon.text = text end
								if hl then icon.highlight = hl end
							end,
						},
					},
				},
			},
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
											local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
											return kind_icon
										end,
										highlight = function(ctx)
											local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
											return hl
										end,
									},
									kind = {
										highlight = function(ctx)
											local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
											return hl
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
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function() require("which-key").show({ global = false }) end,
				desc = "Buffer Local Keymaps",
			},
		},
		---@type wk.Opts
		opts = {
			spec = {
				-- Groups
				{ "<leader>f", group = require("icons").misc.search .. " Find" },
				{ "<leader>g", group = require("icons").git.repo .. " Git", mode = { "n", "v" } },
				{ "<leader>l", group = require("icons").tools.lsp .. " LSP", mode = { "n", "v" } },
				{ "<leader>u", group = require("icons").misc.window .. " UI" },
				{ "<leader>c", group = require("icons").git.repo .. " Logs" },
				{ "<leader>d", group = require("icons").tools.debugger .. " Debugger" },
				{ "<leader>h", group = require("icons").tools.harpoon .. " Harpoon" },
				{ "<leader>T", group = require("icons").tools.tests .. " Tests" },
				{ "<leader>TW", group = require("icons").tools.watch .. " Watch" },
				{ "<leader>a", group = require("icons").tools.robot .. " AI", mode = { "n", "v" } },
				{ "<leader>S", group = require("icons").tools.session .. " Session" },

				-- Naming
				{ "gra", desc = "Code Actions", mode = { "n", "x" } },
				{ "grn", desc = "Rename variable" },
				{ "grr", desc = "LSP References" },
				{ "gri", desc = "Go to implementation" },
				{ "gO", desc = "LSP Outline" },
				{ "<C-S>", desc = "LSP Signature Help", mode = { "i", "s" } },
				{ "]q", desc = "Next quickfix item" },
				{ "[q", desc = "Previous quickfix item" },
				{ "]Q", desc = "Last quickfix item" },
				{ "[Q", desc = "First quickfix item" },
			},
			expand = 1,
			preset = "modern",
			show_help = false,
			icons = { group = "", rules = false },
			win = { no_overlap = false },
			delay = 300,
			---@param ctx { mode: string, operator: string }
			defer = function(ctx)
				if vim.list_contains({ "d", "y" }, ctx.operator) then return true end
				return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
			end,
		},
	},
	{
		"folke/noice.nvim",
		dependencies = { "folke/snacks.nvim", "MunifTanjim/nui.nvim" },
		event = "VeryLazy",
		---@module "noice"
		---@type NoiceConfig
		opts = {
			cmdline = {
				format = {
					search_down = { view = "cmdline" },
					search_up = { view = "cmdline" },
				},
			},
			messages = { view_search = false },
			notify = { enabled = false },
			lsp = {
				progress = { enabled = true },
				hover = { enabled = false },
				signature = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				},
			},
			routes = {
				{ view = "notify", filter = { event = "msg_showmode" } },
			},
			---@type NoicePresets
			presets = {
				bottom_search = false,
				command_palette = false,
				inc_rename = false,
				long_message_to_split = true,
			},
		},
	},
	{
		"petertriho/nvim-scrollbar",
		event = "User File",
		opts = {
			hide_if_all_visible = true,
			excluded_buftypes = { "nofile" },
			excluded_filetypes = {
				"prompt",
				"noice",
				"neo-tree",
				"blink-cmp-menu",
				"blink-cmp-documentation",
				"blink-cmp-signature",
			},
			handlers = {
				gitsigns = true,
				search = true,
			},
		},
	},
	{
		"gbprod/yanky.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = "VeryLazy",
		keys = {
			{
				"<leader>fy",
				---@diagnostic disable-next-line: undefined-field
				function() Snacks.picker.yanky() end,
				desc = "Open Yank History",
				mode = { "n", "x" },
			},
		},
		opts = {},
	},
	{
		"OXY2DEV/helpview.nvim",
		lazy = false, -- this plugin as it is already lazy-loaded
		---@module "helpview"
		---@type helpview.config
		---@diagnostic disable-next-line: missing-fields
		opts = { icon_provider = "mini" },
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "LspAttach",
		keys = {
			{
				"<leader>la",
				function() require("tiny-code-action").code_action({}) end,
				desc = "LSP code action",
			},
		},
		opts = {
			backend = "delta",
			picker = {
				"buffer",
				opts = {
					hotkeys = true,
					auto_preview = true,
					auto_accept = true,
					keymaps = { close = { "q", "<Esc>" } },
				},
			},
			backend_opts = {
				delta = { header_lines_to_remove = 4 },
			},
		},
	},
	{
		"SmiteshP/nvim-navic",
		---@module "nvim-navic"
		---@type Options
		opts = {
			highlight = true,
			click = true,
			lsp = {
				auto_attach = true,
				preference = { "tsgo" },
			},
			safe_output = true,
		},
	},
}
