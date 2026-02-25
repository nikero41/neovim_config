local helpers = require("nikero.helpers")
local hl = vim.api.nvim_set_hl

local ok, catppuccin = pcall(require, "catppuccin.palettes")
if not ok then print("catppuccin.nvim not found") end
local colors = catppuccin.get_palette("mocha")
local cursor_line_bg = helpers:blend(colors.mauve, "#000000", 0.28)

hl(0, "Title", { fg = colors.mauve })
hl(0, "Visual", { bg = helpers:blend(colors.mauve, "#000000", 0.4) })
hl(0, "CursorLine", { bg = cursor_line_bg })
hl(0, "FloatBorder", { fg = colors.mauve })
hl(0, "PmenuSel", { bg = cursor_line_bg, bold = true })
hl(0, "NeoTreeRootName", { fg = colors.mauve })
hl(0, "BlinkCmpMenu", { bg = colors.base, fg = helpers:blend(colors.mauve, "#000000", 0.7) })
hl(0, "HlSearchLensNear", { bg = helpers:blend(colors.mauve, "#000000", 0.85), fg = colors.surface2 })
