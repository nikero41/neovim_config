---@class Autocmds
---@field setup fun(self: Autocmds)
local Autocmds = {}

function Autocmds:setup()
	-- Custom "User File" Event
	--
	-- This autocmd creates a custom `User File` event that provides deferred plugin loading
	-- for file-related plugins. Use `event = "User File"` in lazy.nvim plugin specs instead
	-- of `BufReadPost`/`BufNewFile` for plugins that should load when a real file is opened.
	--
	-- Benefits:
	-- 1. Avoids loading plugins for special buffers (nofile, empty buffers)
	-- 2. Ensures filetype detection completes before plugins load
	-- 3. Prevents duplicate autocmd triggers on config reload by tracking augroups
	--
	-- Usage in plugin specs:
	--   { "some/plugin", event = "User File" }
	--
	-- The event fires after:
	-- - Buffer is valid and listed
	-- - Buffer has a filename (not empty)
	-- - Buffer is not a special buffer (buftype ~= "nofile")
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
		desc = "Events for file detection",
		group = vim.api.nvim_create_augroup("user-file", { clear = true }),
		callback = function(args)
			if vim.b[args.buf].file_checked then return end
			vim.b[args.buf].file_checked = true
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(args.buf) then return end
				local is_valid = vim.bo[args.buf].buflisted

				local current_file = vim.api.nvim_buf_get_name(args.buf)
				if current_file == "" or vim.bo[args.buf].buftype == "nofile" then return end

				local skip_augroups = {}
				for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = args.event })) do
					if autocmd.group_name then skip_augroups[autocmd.group_name] = true end
				end

				skip_augroups["filetypedetect"] = false -- don't skip filetypedetect events
				vim.api.nvim_exec_autocmds("User", { pattern = "File", modeline = false })

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

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		callback = function() vim.hl.on_yank() end,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
		desc = "Use LSP folding if available",
		group = vim.api.nvim_create_augroup("lsp-folding", { clear = true }),
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
		group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
		callback = function()
			local current_tab = vim.fn.tabpagenr()
			vim.cmd.tabdo("wincmd =")
			vim.cmd.tabnext(current_tab)
		end,
	})

	vim.api.nvim_create_autocmd("BufReadPost", {
		desc = "Go to last loc when opening a buffer",
		group = vim.api.nvim_create_augroup("restore-cursor", { clear = true }),
		callback = function(args)
			local exclude = { "gitcommit" }
			local buf = args.buf
			if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].has_cursor_restored then
				return
			end

			vim.b[buf].has_cursor_restored = true
			local mark = vim.api.nvim_buf_get_mark(buf, '"')
			local lcount = vim.api.nvim_buf_line_count(buf)

			if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
		end,
	})

	vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
		desc = "Check if buffers changed on editor focus",
		group = vim.api.nvim_create_augroup("check-buffers", { clear = true }),
		callback = function()
			if vim.bo.buftype ~= "nofile" then vim.cmd.checktime() end
		end,
	})

	vim.api.nvim_create_autocmd("LspProgress", {
		desc = "Show progress bar for LSP progress on terminal",
		group = vim.api.nvim_create_augroup("terminal-progress-bar", { clear = true }),
		callback = function(args)
			local value = args.data.params.value or {}

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
