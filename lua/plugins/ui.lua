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
						kind_icon = {
							provider = function(icon, node)
								icon.text, icon.highlight = require("mini.icons").get("lsp", node.extra.kind.name)
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
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		---@type wk.Opts
		opts = {
			spec = {
				-- Groups
				{ "<leader>f", group = require("icons").Search .. " Find" },
				{ "<leader>g", group = require("icons").Git .. " Git" },
				{ "<leader>l", group = require("icons").LSP .. " LSP" },
				{ "<leader>u", group = require("icons").Window .. " UI" },
				{ "<leader>c", group = require("icons").Git .. " Logs" },
				-- { "<leader>d", group = require("icons").Debugger .. " Debugger" },
				{ "<leader>h", group = require("icons").Harpoon .. " Harpoon" },
				-- { "<leader>T", group = require("icons").Tests .. " Tests" },
				{ "<leader>O", group = require("icons").OpenCode .. " Opencode" },
				{ "<leader>S", group = require("icons").Session .. " Session" },

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
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
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
		"levouh/tint.nvim",
		event = "User File",
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
				function() require("tiny-code-action").code_action() end,
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
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = {
			options = {
				theme = "catppuccin-nvim",
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = { "neo-tree", "snacks_dashboard" },
				},
				always_divide_middle = true,
				always_show_tabline = false,
			},
			sections = {
				lualine_a = {},
				lualine_b = {
					{
						"branch",
						separator = { left = "", right = "" },
						padding = {
							left = 1,
						},
						left_padding = 2,
						right_padding = 2,
						on_click = function() Snacks.lazygit() end,
					},
					"filetype",
				},
				lualine_c = {
					function()
						local current_file = vim.fn.expand("%:p")
						local result = {}
						for id, item in ipairs(require("harpoon"):list().items) do
							local file_path = vim.fn.fnamemodify(item.value, ":p")
							local icon, hl = require("mini.icons").get("file", file_path)
							local icon_str = "%#" .. hl .. "#" .. icon .. "%*"

							local value = string.format("%s %d", icon_str, id)

							if file_path == current_file then
								value = string.format("(%s)", value)
							else
								value = string.format(" %s ", value)
							end

							table.insert(result, #result + 1, value)
						end
						return table.concat(result, "")
					end,
					{
						"diff",
						symbols = {
							added = require("icons").GitAdd .. " ",
							modified = require("icons").GitChange .. " ",
							removed = require("icons").GitDelete .. " ",
						},
					},
					"%=",
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then return "" end
							return require("icons").MacroRecording .. "  " .. reg
						end,
						cond = function() return vim.fn.reg_recording() ~= "" end,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_x = {
					{
						function()
							local linters = require("lint").get_running()
							if #linters == 0 then return require("icons").Active end
							return require("icons").Working .. "  "  .. table.concat(linters, ", ")
						end,
						color = function()
							local linters = require("lint").get_running()
							return { fg = #linters == 0 and "#33aa88" or "" }
						end,
					},
				},
				lualine_y = {
					"diagnostics",
					"progress",
					{
						"location",
						separator = {
							left = "",
							right = "",
						},
						left_padding = 2,
					},
				},
				lualine_z = {},
			},
			tabline = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "tabs", mode = 2, show_modified_status = false } },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {
					{
						"filename",
						file_status = true,
						newfile_status = true,
						path = 1,
						symbols = {
							modified = require("icons").FileModified,
							readonly = require("icons").FileReadOnly,
							unnamed = require("icons").FileNew,
							newfile = require("icons").FileNew,
						},
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {
					{
						"filename",
						file_status = true,
						newfile_status = true,
						path = 1,
						symbols = {
							modified = require("icons").FileModified,
							readonly = require("icons").FileReadOnly,
							unnamed = require("icons").FileNew,
							newfile = require("icons").FileNew,
						},
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "lazy", "man", "mason", "neo-tree", "quickfix", "trouble" },
		},
	},
}
