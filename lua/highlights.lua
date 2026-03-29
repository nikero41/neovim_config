local helpers = require("nikero.helpers")

---@class Highlights
---@field get fun(self: Highlights): table<string, vim.api.keyset.highlight>
---@field setup fun(self: Highlights)
local Highlights = {}

---@param hlgroups table
---@return vim.api.keyset.highlight[]
local function to_hl(hlgroups)
	for _, hl in pairs(hlgroups) do
		local modifiers = vim.split(hl.style or "", ",", { trimempty = true })
		vim
			.iter(modifiers)
			:filter(function(modifier) return modifier ~= "NONE" end)
			:each(function(modifier) hl[modifier] = true end)

		hl.style = nil
	end

	return hlgroups
end

function Highlights:get()
	local theme = require("onedarkpro.theme").load("onedark_vivid")
	local syntax = require("onedarkpro.highlights.syntax").groups(theme)
	local plugins = require("onedarkpro.highlights.plugin").groups(theme)
	local filetypes = require("onedarkpro.highlights.filetype").groups(theme)

	plugins.NeoTreeNormalNC = nil

	local all = to_hl(vim.tbl_deep_extend("force", syntax, plugins, filetypes))

	local colors = require("catppuccin.palettes").get_palette("mocha")
	local cursor_line_bg = helpers:blend(colors.mauve, "#000000", 0.28)

	local highlights = {
		Visual = { bg = helpers:blend(colors.mauve, "#000000", 0.4) },
		CursorLine = { bg = cursor_line_bg },
		FloatBorder = { fg = colors.mauve, bg = colors.mantle },
		PmenuSel = { bg = cursor_line_bg, bold = true },

		-- Snacks
		SnacksTitle = { fg = colors.peach, bg = colors.mantle },
		SnacksPickerTitle = { fg = colors.peach, bg = colors.mantle },
		SnacksPickerToggle = { fg = colors.mauve, bg = colors.mantle },
		SnacksPickerInputBorder = { fg = colors.peach },
		SnacksInputTitle = { fg = colors.peach },
		SnacksInputIcon = { fg = colors.mauve },

		-- Plugins
		NeoTreeRootName = { fg = colors.mauve },
		BlinkCmpMenu = { bg = colors.base, fg = helpers:blend(colors.mauve, "#000000", 0.7) },
		HlSearchLensNear = { bg = helpers:blend(colors.mauve, "#000000", 0.85), fg = colors.surface2 },
		NavicText = { link = "lualine_c_inactive" },
		NavicSeparator = { link = "lualine_c_inactive" },

		-- LSP
		LspReferenceText = { underline = true },
		["@tag.builtin"] = { link = "Special" },
		["@keyword.export"] = { link = "Keyword" },
		["@markup.list.checked"] = { fg = "#d55fde", bg = "NONE" },
		["@parameter"] = { link = "@variable.parameter" },
		["@property.class.css"] = { link = "@property" },
	}

	return vim.tbl_extend("force", all, highlights)
end

function Highlights:setup()
	local groups = self:get()

	for group, hl in pairs(groups) do
		vim.api.nvim_set_hl(0, group, hl)
	end
end

return Highlights
