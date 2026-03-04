---@class Autocmds
---@field setup fun(self: Autocmds)
local Autocmds = {}

function Autocmds:setup()
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		-- group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function() vim.hl.on_yank() end,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
		desc = "Use LSP folding if available",
		callback = function(args)
			if vim.wo.foldexpr == "v:lua.vim.lsp.foldexpr()" then return end

			for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
				if c.server_capabilities and c.server_capabilities.foldingRangeProvider then
					vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
					pcall(vim.lsp.buf.refresh_folds, { bufnr = args.buf })
					return
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimResized", {
		desc = "Resize splits if window got resized",
		-- group = augroup("resize_splits"),
		callback = function()
			local current_tab = vim.fn.tabpagenr()
			vim.cmd.tabdo("wincmd =")
			vim.cmd.tabnext(current_tab)
		end,
	})

	vim.api.nvim_create_autocmd("BufReadPost", {
		desc = "Go to last loc when opening a buffer",
		-- group = augroup("last_loc"),
		callback = function(event)
			local exclude = { "gitcommit" }
			local buf = event.buf
			if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_location then return end

			vim.b[buf].last_location = true
			local mark = vim.api.nvim_buf_get_mark(buf, '"')
			local lcount = vim.api.nvim_buf_line_count(buf)

			if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
		end,
	})

	vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
		desc = "Check if buffers changed on editor focus",
		callback = function()
			if vim.bo.buftype ~= "nofile" then vim.cmd.checktime() end
		end,
	})

	vim.api.nvim_create_autocmd("LspProgress", {
		callback = function(event)
			local value = event.data.params.value or {}

			local progress_bar = require("nikero.progress_bar")

			if value.kind == "end" then
				progress_bar:clear()
				return
			elseif value.percentage ~= nil then
				progress_bar:progress(value.percentage)
			else
				progress_bar:loading()
			end
		end,
	})
end

return Autocmds
