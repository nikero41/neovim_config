local ok, colors = pcall(function() return require("catppuccin.palettes").get_palette("mocha") end)
if not ok then error("catppuccin.nvim not found") end
local cursor_line_bg = require("nikero.utils"):blend(colors.mauve, "#000000", 0.28)

---@type LazySpec
return {
	"AstroNvim/astroui",
	---@type AstroUIOpts
	opts = {
		colorscheme = require("colorscheme"),
		highlights = {
			init = {
				DiagnosticUnderlineError = { undercurl = true, sp = "#ef596f" },
				DiagnosticUnderlineHint = { undercurl = true, sp = "#2bbac5" },
				DiagnosticUnderlineInfo = { undercurl = true, sp = "#61afef" },
				DiagnosticUnderlineWarn = { undercurl = true, sp = "#e5c07b" },
				CursorLine = { bg = cursor_line_bg },
				Visual = { bg = require("nikero.utils"):blend(colors.mauve, "#000000", 0.4) },
				PmenuSel = { bg = cursor_line_bg, bold = true },
				Title = { fg = colors.mauve },
				BlinkCmpMenuBorder = {
					bg = colors.base,
					fg = require("nikero.utils"):blend(colors.mauve, "#000000", 0.7),
				},
				NeoTreeRootName = { fg = colors.mauve },
				BlinkCmpMenu = { bg = colors.base },
				FloatBorder = { fg = colors.mauve },
				HlSearchLensNear = {
					bg = require("nikero.utils"):blend(colors.mauve, "#000000", 0.85),
					fg = colors.surface2,
				},
			},
			onedark_vivid = {
				["@markup.list.checked"] = { fg = "#d55fde", bg = "NONE" },
			},
		},
		icons = {
			LSPLoading1 = "⠋",
			LSPLoading2 = "⠙",
			LSPLoading3 = "⠹",
			LSPLoading4 = "⠸",
			LSPLoading5 = "⠼",
			LSPLoading6 = "⠴",
			LSPLoading7 = "⠦",
			LSPLoading8 = "⠧",
			LSPLoading9 = "⠇",
			LSPLoading10 = "⠏",
		},
		status = {
			colors = {
				diag_ERROR = "#ec5f67",
				diag_WARN = "#ebae34",
				diag_INFO = "#40d9ff",
				diag_HINT = "#ff9640",
			},
			icon_highlights = {
				breadcrumbs = true,
				file_icon = {
					statusline = true,
					winbar = true,
				},
			},
		},
	},
}
