local keymaps = require("nikero.keymaps"):new()

-- General
keymaps:add_multiple({
	{ { "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down" } },
	{ { "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move down" } },

	{ "n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" } },
	{ "n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" } },
	{ "n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" } },
	{ "n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" } },

	{ "n", "<leader>q", "<CMD>confirm q<CR>", { desc = "Close window" } },
	{ "n", "<leader>Q", "<CMD>confirm qall<CR>", { desc = "Quit nvim" } },
	{
		"n",
		"<leader>C",
		function()
			local bufs = vim.fn.getbufinfo({ buflisted = 1 })
			local buffer = vim.api.nvim_get_current_buf()
			Snacks.bufdelete({ buf = buffer })
			if not bufs[2] then Snacks.dashboard.open() end
		end,
		{ desc = "Close buffer" },
	},
})

-- Buffers
keymaps:add_multiple({
	{ "n", "\\", vim.cmd.split, { desc = "Horizontal split" } },
	{ "n", "|", vim.cmd.vsplit, { desc = "Vertical split" } },
	{ "v", "<S-Tab>", "<gv", { desc = "Unindent line" } },
	{ "v", "<Tab>", ">gv", { desc = "Indent line" } },
	{
		"n",
		"<leader>uw",
		function()
			vim.wo.wrap = not vim.wo.wrap
			vim.notify("wrap " .. (vim.wo.wrap and "enabled" or "disabled"), vim.log.levels.INFO, { title = "Line Wrap" })
		end,
		{ desc = "Toggle line wrap" },
	},
})

-- Comment
keymaps:add_multiple({
	{ "n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" } },
	{ "x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" } },
	{ "n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Insert comment below current line" } },
	{ "n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Insert comment above current line" } },
})

-- Navigation
keymaps:add_multiple({
	{ "n", "]t", vim.cmd.tabnext, { desc = "Next tab" } },
	{ "n", "[t", vim.cmd.tabprevious, { desc = "Previous tab" } },
})

-- QList
keymaps:add_multiple({
	{ "n", "]q", vim.cmd.cnext, { desc = "Next quickfix item" } },
	{ "n", "[q", vim.cmd.cprevious, { desc = "Previous quickfix item" } },
})

-- Search
keymaps:add_multiple({
	{
		"n",
		"n",
		function()
			vim.cmd("normal! nzz")
			require("hlslens").start()
		end,
		{ desc = "Next result" },
	},
	{
		"n",
		"N",
		function()
			vim.cmd("normal! Nzz")
			require("hlslens").start()
		end,
		{ desc = "Previous result" },
	},
	{
		{ "i", "n", "s" },
		"<Esc>",
		function()
			vim.cmd("noh")
			require("luasnip").unlink_current()
			return "<Esc>"
		end,
		{ expr = true, desc = "Escape and Clear hlsearch" },
	},
})

-- Clipboard
keymaps:add_multiple({
	{ "x", "<Leader>p", '"_dP', { desc = "Paste without coping" } },
	{ "n", "<Leader>y", '"+y', { desc = "Yank to clipboard" } },
	{ "x", "<Leader>y", '"+y', { desc = "Yank to clipboard" } },
	{ "n", "<Leader>Y", '"+Y', { desc = "Yank rest of line to clipboard" } },
	{ "x", "<Leader>Y", '"+Y', { desc = "Yank rest of line to clipboard" } },
	{ "x", "<Leader>D", '"_d', { desc = "Cut" } },
	{ "n", "<Leader>D", '"_d', { desc = "Cut" } },
})

keymaps:add({ "n", "gl", function() vim.diagnostic.open_float() end, { desc = "Diagnostics popup" } })

keymaps:add({
	"n",
	"<Leader>ltl",
	function()
		vim.g.enable_golines = not vim.g.enable_golines
		vim.notify(
			"goliens " .. (vim.g.enable_golines and "enabled" or "disabled"),
			vim.log.levels.INFO,
			{ title = "LSP toggle" }
		)
	end,
	{ desc = "Toggle golines" },
})

return keymaps
