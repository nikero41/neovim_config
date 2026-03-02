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
		vim.cmd("tabdo wincmd =")
		-- TODO: vim.cmd.wincmd({ "=",  })
		vim.cmd.tabnext(current_tab)
	end,
})
