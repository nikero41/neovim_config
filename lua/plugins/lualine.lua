---@type LazySpec
return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = { "neo-tree", "snacks_dashboard", "qf", "noice", "trouble", "help" },
				},
				always_divide_middle = true,
				always_show_tabline = false,
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"project",
						format = "short",
						no_project = "N/A",
						color = function()
							return { fg = require("catppuccin.palettes").get_palette("mocha").blue }
						end,
					},
					{
						"branch",
						icon = require("icons").git.branch,
						on_click = function() Snacks.lazygit() end,
						color = function()
							return { fg = require("catppuccin.palettes").get_palette("mocha").green }
						end,
					},
					{ "filetype", separator = "│" },
					{
						function(fmt) return require("nikero.statusline"):harpoon_widget(fmt.default_hl) end,
						condition = function() return #require("harpoon"):list().items ~= 0 end,
						separator = "│",
						padding = 0,
					},
					{
						"diff",
						diff_color = {
							added = "@diff.plus",
							modified = "@diff.delta",
							removed = "@diff.minus",
						},
						symbols = {
							added = require("icons").git.add .. " ",
							modified = require("icons").git.modified .. " ",
							removed = require("icons").git.removed .. " ",
						},
					},
					{
						-- q recording
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then return "" end
							return "%=" .. require("icons").tools.macro_recording .. "  " .. reg
						end,
						cond = function() return vim.fn.reg_recording() ~= "" end,
						-- TODO:
						color = "SpecialChar",
					},
				},
				lualine_x = {
					{ function() return require("wtf").get_status() end },
					{
						function()
							local linters = require("lint").get_running()
							return require("icons").status.working .. "  " .. table.concat(linters, ", ")
						end,
						cond = function() return #require("lint").get_running() ~= 0 end,
						color = function()
							return { fg = require("catppuccin.palettes").get_palette("mocha").peach }
						end,
					},
					{
						"diagnostics",
						symbols = {
							error = require("icons").diagnostics.error .. " ",
							warn = require("icons").diagnostics.warn .. " ",
							info = require("icons").diagnostics.info .. " ",
							hint = require("icons").diagnostics.hint .. " ",
						},
					},
					{
						"progress",
						color = function()
							return { fg = require("catppuccin.palettes").get_palette("mocha").flamingo }
						end,
					},
					{
						"location",
						color = function()
							return { fg = require("catppuccin.palettes").get_palette("mocha").mauve }
						end,
					},
				},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"tabs",
						mode = 2,
						section_separators = { left = "", right = "" },
						show_modified_status = false,
						tabs_color = {
							active = "lualine_a_normal",
							inactive = "lualine_c_inactive",
						},
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {
					{ "filetype", icon_only = true },
					{
						"filename",
						separator = { right = "" },
						padding = { left = 0, right = 1 },
						file_status = true,
						newfile_status = true,
						path = 1,
						symbols = {
							modified = require("icons").files.modified,
							readonly = require("icons").files.read_only,
							unnamed = require("icons").files.new,
							newfile = require("icons").files.new,
						},
					},
				},
				lualine_c = {
					{ "navic", color_correction = "static", draw_empty = true },
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {
					{ "filetype", colored = false, icon_only = true },
					{
						"filename",
						separator = { right = "" },
						padding = { left = 0, right = 1 },
						file_status = true,
						newfile_status = true,
						path = 1,
						symbols = {
							modified = require("icons").files.modified,
							readonly = require("icons").files.read_only,
							unnamed = require("icons").files.new,
							newfile = require("icons").files.new,
						},
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "lazy", "man", "mason", "trouble" },
		},
		config = function(_, opts)
			local lualine_require = require("lualine_require")
			lualine_require.require = require
			require("lualine").setup(opts)
		end,
	},
}
