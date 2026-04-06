---@class Autocmds
---@field setup fun(self: Autocmds)
---@field lsp_setup fun(self: Autocmds)
local Autocmds = {}

function Autocmds:lsp_setup()
	local events = { "BufEnter", "LspAttach" }

	vim.api.nvim_create_autocmd(events, {
		desc = "Use LSP folding if available",
		group = vim.api.nvim_create_augroup("lsp-folding", { clear = true }),
		callback = function(args)
			local has_lsp_folding = vim.iter(vim.lsp.get_clients({ bufnr = args.buf })):any(
				function(client) return client:supports_method("textDocument/foldingRange") end
			)
			local foldexpr = has_lsp_folding and "v:lua.vim.lsp.foldexpr()"
				or "v:lua.vim.treesitter.foldexpr()"

			vim
				.iter(vim.fn.win_findbuf(args.buf))
				:filter(function(winid) return vim.wo[winid].foldexpr ~= foldexpr end)
				:each(function(winid)
					vim.wo[winid].foldexpr = foldexpr
					vim.api.nvim_win_call(winid, function() vim.cmd("normal! zx") end)
				end)
		end,
	})

	vim.api.nvim_create_autocmd(events, {
		desc = "Don't use LSP document colors if available",
		group = vim.api.nvim_create_augroup("lsp-document-colors", { clear = true }),
		callback = function(args)
			local has_document_color = vim.iter(vim.lsp.get_clients({ bufnr = args.buf })):any(
				function(client) return client:supports_method("textDocument/documentColor") end
			)
			if has_document_color then
				vim.lsp.document_color.enable(false, { bufnr = args.buf }, { style = "virtual" })
			end
		end,
	})

	vim.api.nvim_create_autocmd(events, {
		desc = "Enable inlay hints",
		group = vim.api.nvim_create_augroup("lsp-inlay-hints", { clear = true }),
		callback = function(args)
			local has_inlay_hints = vim.iter(vim.lsp.get_clients({ bufnr = args.buf })):any(
				function(client) return client:supports_method("textDocument/inlayHint") end
			)
			if has_inlay_hints then vim.lsp.inlay_hint.enable(true, { bufnr = args.buf }) end
		end,
	})

	vim.api.nvim_create_autocmd(events, {
		desc = "Enable code lens",
		group = vim.api.nvim_create_augroup("lsp-code-lens", { clear = true }),
		callback = function(args)
			local has_code_lens = vim.iter(vim.lsp.get_clients({ bufnr = args.buf })):any(
				function(client) return client:supports_method("textDocument/codeLens") end
			)
			local should_enable =
				not vim.tbl_contains(require("nikero.config").hide_code_lens_ft, vim.bo[args.buf].filetype)
			if has_code_lens then vim.lsp.codelens.enable(should_enable, { bufnr = args.buf }) end
		end,
	})
end

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
			if not vim.api.nvim_buf_is_valid(args.buf) then return end

			local current_file = vim.api.nvim_buf_get_name(args.buf)
			local buftype = vim.bo[args.buf].buftype
			if not vim.bo[args.buf].buflisted or current_file == "" or buftype ~= "" then return end

			local skip_augroups = vim
				.iter(vim.api.nvim_get_autocmds({ event = args.event }))
				:filter(function(autocmd) return autocmd.group_name end)
				:fold({}, function(acc, autocmd)
					acc[autocmd.group_name] = true
					return acc
				end)

			skip_augroups["filetypedetect"] = false -- don't skip filetypedetect events
			vim.api.nvim_exec_autocmds("User", { pattern = "File", modeline = false })

			vim.schedule(function()
				vim
					.iter(vim.api.nvim_get_autocmds({ event = args.event }))
					:filter(
						function(autocmd) return autocmd.group_name and not skip_augroups[autocmd.group_name] end
					)
					:each(function(autocmd)
						vim.api.nvim_exec_autocmds(
							args.event,
							{ group = autocmd.group_name, buffer = args.buf, data = args.data }
						)
						skip_augroups[autocmd.group_name] = true
					end)
			end)
		end,
	})

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking text",
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		callback = function() vim.hl.on_yank() end,
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
		callback = function(args) require("nikero.progress_bar"):on_lsp_progress(args) end,
	})

	self:lsp_setup()
end

return Autocmds
