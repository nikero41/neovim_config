---@type LazySpec
return {
	{
		"nvim-mini/mini.icons",
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		specs = {
			{
				"saghen/blink.cmp",
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
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		---@type WhichKeyConfig
		opts = {
			preset = "modern",
			icons = {
				group = "",
				rules = false,
			},
			win = {
				no_overlap = false,
			},
		},
	},
	{
		"folke/noice.nvim",
		dependencies = { "folke/snacks.nvim", "MunifTanjim/nui.nvim" },
		event = "VeryLazy",
		---@module "noice"
		---@type NoiceConfig
		opts = {
			messages = { view_search = false },
			notify = { enabled = false },
			lsp = {
				progress = { enabled = true },
				hover = { enabled = false },
				signature = { enabled = false },
				-- override = {
				-- 	["vim.lsp.buf.hover"] = false,
				-- 	["vim.lsp.buf.signature_help"] = false,
				-- },
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
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		-- TODO:
		-- dependencies = {
		-- 	"AstroNvim/astrocore",
		-- 	---@param opts AstroCoreOpts
		-- 	opts = function(_, opts)
		-- 		if not opts.signs then opts.signs = {} end
		-- 		opts.signs.BqfSign = { text = " " .. require("astroui").get_icon("Selected"), texthl = "BqfSign" }
		-- 	end,
		-- },
		opts = {},
	},
	{
		"petertriho/nvim-scrollbar",
		opts = {
			excluded_buftypes = { "nofile" },
			excluded_filetypes = {
				"prompt",
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
		"levouh/tint.nvim",
		event = "User AstroFile",
		opts = {
			highlight_ignore_patterns = { "WinSeparator", "NeoTree", "Status.*" },
			tint = -45,
			saturation = 0.6,
		},
	},
	{
		"gbprod/yanky.nvim",
		dependencies = { "folke/snacks.nvim" },
		event = "VeryLazy",
		keys = {
			{
				"<leader>fy",
				function() Snacks.picker.yanky() end,
				mode = { "n", "x" },
				desc = "Open Yank History",
			},
		},
		opts = {},
	},
}
