local function print_filetype()
	local winid = vim.fn.getmousepos().winid
	if winid == 0 or not vim.api.nvim_win_is_valid(winid) then return end

	local bufnr = vim.api.nvim_win_get_buf(winid)
	local file_path = vim.api.nvim_buf_get_name(bufnr)
	local icon, hl = require("mini.icons").get("file", file_path)
	vim.notify(("%s %s"):format(icon, vim.bo[bufnr].filetype), vim.log.levels.INFO, {
		title = vim.fs.basename(file_path),
		---@diagnostic disable-next-line: missing-fields
		hl = { msg = hl },
	})
end

---@type LazySpec
return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = function()
			local colors = require("catppuccin.palettes").get_palette("mocha")

			return {
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
							on_click = function() vim.cmd.Project() end,
							color = { fg = colors.blue },
						},
						{
							"branch",
							icon = require("icons").git.branch,
							color = { fg = colors.green },
							separator = "│",
							on_click = function() Snacks.lazygit() end,
						},
						{
							function(fmt) return require("nikero.statusline"):harpoon_widget(fmt.default_hl) end,
							cond = function() return #require("harpoon"):list().items ~= 0 end,
							padding = 0,
						},
						{
							-- q recording
							function()
								local reg = vim.fn.reg_recording()
								if reg == "" then return "" end
								return "%=" .. require("icons").tools.macro_recording .. "  " .. reg
							end,
							cond = function() return vim.fn.reg_recording() ~= "" end,
							color = { fg = colors.red },
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
							color = { fg = colors.peach },
						},
						{
							"diff",
							diff_color = {
								added = "@diff.plus",
								modified = "NeoTreeGitModified",
								removed = "@diff.minus",
							},
							symbols = {
								added = require("icons").git.add .. " ",
								modified = require("icons").git.modified .. " ",
								removed = require("icons").git.removed .. " ",
							},
							separator = "│",
						},
						{ "progress", color = { fg = colors.flamingo } },
						{ "location", color = { fg = colors.mauve } },
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
						{ "filetype", icon_only = true, on_click = print_filetype },
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
						{
							"navic",
							fmt = function(self) return string.sub(self, 1, -3) .. "%#lualine_c_normal#" end,
							color_correction = "dynamic",
							draw_empty = false,
						},
					},
					lualine_x = {},
					lualine_y = {
						{
							"diagnostics",
							symbols = {
								error = require("icons").diagnostics.error .. " ",
								warn = require("icons").diagnostics.warn .. " ",
								info = require("icons").diagnostics.info .. " ",
								hint = require("icons").diagnostics.hint .. " ",
							},
							separator = { left = "" },
						},
					},
					lualine_z = {},
				},
				inactive_winbar = {
					lualine_a = {
						{ "filetype", colored = false, icon_only = true, on_click = print_filetype },
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
					lualine_b = {},
					lualine_c = {},
					lualine_x = {
						{
							"diagnostics",
							symbols = {
								error = require("icons").diagnostics.error .. " ",
								warn = require("icons").diagnostics.warn .. " ",
								info = require("icons").diagnostics.info .. " ",
								hint = require("icons").diagnostics.hint .. " ",
							},
							separator = { left = "" },
						},
					},
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "lazy", "man", "mason", "trouble" },
			}
		end,
		config = function(_, opts)
			local lualine_require = require("lualine_require")
			lualine_require.require = require
			require("lualine").setup(opts)
		end,
	},
}
