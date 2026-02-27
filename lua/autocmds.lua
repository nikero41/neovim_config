vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	-- group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function() vim.hl.on_yank() end,
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
