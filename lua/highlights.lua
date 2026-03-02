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

	-- TODO: move this
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
		desc = "Events for file detection",
		callback = function(args)
			if vim.b[args.buf].astrofile_checked then return end
			vim.b[args.buf].astrofile_checked = true
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(args.buf) then return end
				local is_valid = vim.bo[args.buf].buflisted

				local current_file = vim.api.nvim_buf_get_name(args.buf)

				if not vim.g.vscode and (current_file == "" or vim.bo[args.buf].buftype == "nofile") then return end

				local skip_augroups = {}
				for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
					if autocmd.group_name then skip_augroups[autocmd.group_name] = true end
				end

				skip_augroups["filetypedetect"] = false -- don't skip filetypedetect events
				vim.api.nvim_exec_autocmds("User", { pattern = "NikeroFile", modeline = false })

				local folder = vim.fn.fnamemodify(current_file, ":p:h")

				-- if astro.cmd({ "git", "-C", folder, "rev-parse" }, false) or astro.file_worktree() then
				vim.api.nvim_exec_autocmds("User", { pattern = "NikeroGitFile", modeline = false })
				-- 	-- astro.event("GitFile")
				-- 	pcall(vim.api.nvim_del_augroup_by_name, "file_user_events")
				-- end

				if not is_valid then return end

				vim.schedule(function()
					for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
						if autocmd.group_name and not skip_augroups[autocmd.group_name] then
							vim.api.nvim_exec_autocmds(
								args.event,
								{ group = autocmd.group_name, buffer = args.buf, data = args.data }
							)
							skip_augroups[autocmd.group_name] = true
						end
					end
				end)
			end)
		end,
	})
end

return Highlights
