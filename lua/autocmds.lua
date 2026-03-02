---@class Autocmds
---@field setup fun(self: Autocmds)
local Autocmds = {}

function Autocmds:setup()
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		-- group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function() vim.hl.on_yank() end,
	})

	-- use LSP folding if available
	vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
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

	-- resize splits if window got resized
	vim.api.nvim_create_autocmd("VimResized", {
		-- group = augroup("resize_splits"),
		callback = function()
			local current_tab = vim.fn.tabpagenr()
			vim.cmd.tabdo("wincmd =")
			vim.cmd.tabnext(current_tab)
		end,
	})

	-- TODO: go to last loc when opening a buffer
	vim.api.nvim_create_autocmd("BufReadPost", {
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

	-- vim.api.nvim_create_autocmd("LspProgress", {
	-- 	callback = function(event)
	-- 		local value = event.data.params.value or {}
	-- 		local msg = value.message or "done"
	--
	-- 		-- rust analyszer in particular has really long LSP messages so truncate them
	-- 		if #msg > 40 then msg = msg:sub(1, 37) .. "..." end
	--
	-- 		local status = value.kind == "end" and 0 or 1
	-- 		local percent = value.percentage or 0
	--
	-- 		local osc_seq = string.format("\27]9;4;%d;%d\a", status, percent)
	--
	-- 		if os.getenv("TMUX") then osc_seq = string.format("\27Ptmux;\27%s\27\\", osc_seq) end
	-- 		-- vim.api.nvim_chan_send(vim.v.stderr, osc_seq)
	-- 		io.stdout:write(osc_seq)
	-- 		io.stdout:flush()
	-- 		-- vim.api.nvim_echo({ { msg } }, false, {
	-- 		-- 	id = "lsp",
	-- 		-- 	kind = "progress",
	-- 		-- 	title = value.title,
	-- 		-- 	status = value.kind ~= "end" and "running" or "success",
	-- 		-- 	percent = value.percentage,
	-- 		-- })
	-- 	end,
	-- })
end

return Autocmds
