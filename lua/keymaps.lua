local keymaps = require("nikero.keymaps"):new()

-- General
keymaps:add({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down" })
keymaps:add({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move down" })

keymaps:add("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymaps:add("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymaps:add("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymaps:add("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

keymaps:add("n", "<leader>q", "<CMD>confirm q<CR>", { desc = "Close window" })
keymaps:add("n", "<leader>Q", "<CMD>confirm qall<CR>", { desc = "Quit nvim" })
keymaps:add("n", "<leader>C", function()
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	local bufnr = vim.api.nvim_get_current_buf()
	Snacks.bufdelete({ buf = bufnr })
	if not bufs[2] then Snacks.dashboard.open() end
end, { desc = "Close buffer" })

-- Buffers
keymaps:add("n", "\\", vim.cmd.split, { desc = "Horizontal split" })
keymaps:add("n", "|", vim.cmd.vsplit, { desc = "Vertical split" })
keymaps:add("v", "<S-Tab>", "<gv", { desc = "Unindent line" })
keymaps:add("v", "<Tab>", ">gv", { desc = "Indent line" })
keymaps:add("n", "<leader>uw", function() vim.opt.wrap = not vim.opt.wrap end, { desc = "Toggle line wrap" })

-- Comment
keymaps:add("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
keymaps:add("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })
keymaps:add("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Insert comment below current line" })
keymaps:add("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Insert comment above current line" })

-- Navigation
keymaps:add("n", "]t", vim.cmd.tabnext, { desc = "Next tab" })
keymaps:add("n", "[t", vim.cmd.tabprevious, { desc = "Previous tab" })

-- QList
keymaps:add("n", "]q", vim.cmd.cnext, { desc = "Next quickfix item" })
keymaps:add("n", "[q", vim.cmd.cprevious, { desc = "Previous quickfix item" })

-- Search
keymaps:add("n", "n", function()
	vim.cmd("normal! nzz")
	require("hlslens").start()
end, { desc = "Next result" })
keymaps:add("n", "N", function()
	vim.cmd("normal! Nzz")
	require("hlslens").start()
end, { desc = "Previous result" })

-- Clipboard
keymaps:add("x", "<Leader>p", '"_dP', { desc = "Paste without coping" })
keymaps:add("n", "<Leader>y", '"+y', { desc = "Yank to clipboard" })
keymaps:add("x", "<Leader>y", '"+y', { desc = "Yank to clipboard" })
keymaps:add("n", "<Leader>Y", '"+Y', { desc = "Yank rest of line to clipboard" })
keymaps:add("x", "<Leader>Y", '"+Y', { desc = "Yank rest of line to clipboard" })
keymaps:add("x", "<Leader>D", '"_d', { desc = "Cut" })
keymaps:add("n", "<Leader>D", '"_d', { desc = "Cut" })

keymaps:add("n", "<Leader>ltl", function()
	vim.g.enable_golines = not vim.g.enable_golines
	vim.notify(
		"goliens " .. (vim.g.enable_golines and "enabled" or "disabled"),
		vim.log.levels.INFO,
		{ title = "LSP toggle" }
	)
end, { desc = "Toggle golines" })

keymaps:setup()
