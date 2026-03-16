local helpers = require("nikero.helpers")

---@class Highlights
---@field get fun(self: Highlights): table<string, vim.api.keyset.highlight>
---@field setup fun(self: Highlights)
local Highlights = {}

---@return vim.api.keyset.highlight[]
local function to_hl(all)
	for _, hl in pairs(all) do
		if hl.style ~= nil then
			if hl.style == "NONE" then
				hl.style = nil
			else
				for _, style in pairs(hl.style) do
					hl[style] = true
				end
				hl.style = nil
			end
		end
	end

	return all
end

function Highlights:get()
	local theme = require("onedarkpro.theme").load("onedark_vivid")
	local syntax = require("onedarkpro.highlights.syntax").groups(theme)
	local plugins = require("onedarkpro.highlights.plugin").groups(theme)
	local filetypes = require("onedarkpro.highlights.filetype").groups(theme)

	local all = to_hl(vim.tbl_deep_extend("force", syntax, plugins, filetypes))

	local colors = require("catppuccin.palettes").get_palette("mocha")
	local cursor_line_bg = helpers:blend(colors.mauve, "#000000", 0.28)

	local highlights = {
		Title = { fg = colors.mauve },
		Visual = { bg = helpers:blend(colors.mauve, "#000000", 0.4) },
		CursorLine = { bg = cursor_line_bg },
		FloatBorder = { fg = colors.mauve, bg = "NONE" },
		PmenuSel = { bg = cursor_line_bg, bold = true },
		NeoTreeRootName = { fg = colors.mauve },
		BlinkCmpMenu = { bg = colors.base, fg = helpers:blend(colors.mauve, "#000000", 0.7) },
		HlSearchLensNear = { bg = helpers:blend(colors.mauve, "#000000", 0.85), fg = colors.surface2 },
		["@tag.builtin"] = { link = "Special" },
		["@keyword.export"] = { link = "Keyword" },
		["@markup.list.checked"] = { fg = "#d55fde", bg = "NONE" },
		LspReferenceText = { underline = true },
		NavicText = { link = "lualine_c_inactive" },
		NavicSeparator = { link = "lualine_c_inactive" },
	}

	return vim.tbl_extend("force", to_hl(all), highlights)
end

function Highlights:setup()
	local groups = self:get()

	for group, hl in pairs(groups) do
		vim.api.nvim_set_hl(0, group, hl)
	end
end

return Highlights
