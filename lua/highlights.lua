---@class Highlights
---@field setup fun(self: Highlights)
local Highlights = {}

function Highlights:setup()
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

	hl(0, "@markup.list.checked", { fg = "#d55fde", bg = "NONE" })
	hl(0, "LspReferenceText", { underline = true })
	-- DiagnosticUnderlineError = { undercurl = true, sp = "#ef596f" },
	-- DiagnosticUnderlineHint = { undercurl = true, sp = "#2bbac5" },
	-- DiagnosticUnderlineInfo = { undercurl = true, sp = "#61afef" },
	-- DiagnosticUnderlineWarn = { undercurl = true, sp = "#e5c07b" },

	-- q_close_windows = {
	--         {
	--           event = "BufWinEnter",
	--           desc = "Make q close help, man, quickfix, dap floats",
	--           callback = function(args)
	--             -- Add cache for buffers that have already had mappings created
	--             if not vim.g.q_close_windows then vim.g.q_close_windows = {} end
	--             -- If the buffer has been checked already, skip
	--             if vim.g.q_close_windows[args.buf] then return end
	--             -- Mark the buffer as checked
	--             vim.g.q_close_windows[args.buf] = true
	--             -- Check to see if `q` is already mapped to the buffer (avoids overwriting)
	--             for _, map in ipairs(vim.api.nvim_buf_get_keymap(args.buf, "n")) do
	--               if map.lhs == "q" then return end
	--             end
	--             -- If there is no q mapping already and the buftype is a non-real file, create one
	--             if vim.tbl_contains({ "help", "nofile", "quickfix" }, vim.bo[args.buf].buftype) then
	--               vim.keymap.set("n", "q", "<Cmd>close<CR>", {
	--                 desc = "Close window",
	--                 buffer = args.buf,
	--                 silent = true,
	--                 nowait = true,
	--               })
	--             end
	--           end,
	--         },
	--         {
	--           event = "BufDelete",
	--           desc = "Clean up q_close_windows cache",
	--           callback = function(args)
	--             if vim.g.q_close_windows then vim.g.q_close_windows[args.buf] = nil end
	--           end,
	--         },
	--       },
	--       restore_cursor = {
	--         {
	--           event = "BufReadPost",
	--           desc = "Restore last cursor position when opening a file",
	--           callback = function(args)
	--             local buf = args.buf
	--             if vim.b[buf].last_loc_restored or vim.tbl_contains({ "gitcommit" }, vim.bo[buf].filetype) then return end
	--             vim.b[buf].last_loc_restored = true
	--             local mark = vim.api.nvim_buf_get_mark(buf, '"')
	--             if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(buf) then
	--               pcall(vim.api.nvim_win_set_cursor, 0, mark)
	--             end
	--           end,
	--         },
	--       },
end

return Highlights
