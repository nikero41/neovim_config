---@type LazySpec
return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = {
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = { "neo-tree", "snacks_dashboard", "qf", "noice", "trouble", "help" },
				},
				always_divide_middle = true,
				always_show_tabline = false,
			},
			sections = {
				lualine_a = {},
				lualine_b = {
					{
						-- Separator to set the left edge
						function() return "" end,
						draw_empty = true,
						separator = { left = "" },
					},
					{ "project", format = "short", no_project = "N/A" },
					{ "branch", on_click = function() Snacks.lazygit() end },
					"filetype",
				},
				lualine_c = {
					{
						-- harpoon
						function(fmt)
							local current_file = vim.fn.expand("%:p")
							return vim
								.iter(ipairs(require("harpoon"):list().items))
								:map(function(index, item)
									local file_path = vim.fn.fnamemodify(item.value, ":p")
									local icon, hl = require("mini.icons").get("file", file_path)
									local new_hl = require("nikero.lualine"):statusline_icon_hl(hl, fmt.default_hl)
									local icon_str = "%#" .. new_hl .. "#" .. icon .. "%*" .. fmt.default_hl

									local value = string.format("%s %d", icon_str, index)

									if file_path == current_file then
										value = string.format("(%s)", value)
									else
										value = string.format(" %s ", value)
									end

									return value
								end)
								:join("")
						end,
					},
					{
						"diff",
						padding = { left = 2 },
						symbols = {
							added = require("icons").git.add .. " ",
							modified = require("icons").git.modified .. " ",
							removed = require("icons").git.removed .. " ",
						},
						separator = "",
					},
					{ "%=", separator = "" },
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then return "" end
							return require("icons").tools.macro_recording .. "  " .. reg
						end,
						cond = function() return vim.fn.reg_recording() ~= "" end,
					},
				},
				lualine_x = {
					{ function() return require("wtf").get_status() end },
					{
						function()
							local linters = require("lint").get_running()
							if #linters == 0 then return require("icons").status.active .. " " end
							return require("icons").status.working .. "  " .. table.concat(linters, ", ")
						end,
						color = function()
							local linters = require("lint").get_running()
							return { fg = #linters == 0 and "#33aa88" or nil }
						end,
					},
					{
						"diagnostics",
						padding = 2,
						symbols = {
							error = require("icons").diagnostics.error .. " ",
							warn = require("icons").diagnostics.warn .. " ",
							info = require("icons").diagnostics.info .. " ",
							hint = require("icons").diagnostics.hint .. " ",
						},
					},
				},
				lualine_y = {
					{ "progress", padding = { left = 1, right = 2 } },
					{ "location", separator = { right = "" } },
				},
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
					{
						"filetype",
						separator = { left = "" },
						padding = { left = 1, right = 0 },
						icon_only = true,
					},
					{
						"filename",
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
					{
						"filetype",
						separator = "",
						padding = { left = 2, right = 0 },
						colored = false,
						icon_only = true,
					},
					{
						"filename",
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
