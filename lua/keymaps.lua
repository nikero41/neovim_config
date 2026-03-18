local keymaps = require("nikero.keymaps"):new()

-- General
keymaps:add_multiple({
	{ { "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down" } },
	{ { "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up" } },

	{ "n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", optional = true } },
	{ "n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", optional = true } },
	{ "n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window", optional = true } },
	{ "n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window", optional = true } },

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
	{ "n", "<leader>P", vim.cmd.CommandPalette, { desc = "Command Palette" } },
})

-- Buffers
keymaps:add_multiple({
	{ "n", "\\", vim.cmd.split, { desc = "Horizontal split" } },
	{ "n", "|", vim.cmd.vsplit, { desc = "Vertical split" } },
	{ "v", "<S-Tab>", "<gv", { desc = "Unindent line", unique = false } },
	{ "v", "<Tab>", ">gv", { desc = "Indent line", unique = false } },
	{
		"n",
		"<leader>uw",
		function()
			vim.wo.wrap = not vim.wo.wrap
			vim.notify(
				"wrap " .. (vim.wo.wrap and "enabled" or "disabled"),
				vim.log.levels.INFO,
				{ title = "Line Wrap" }
			)
		end,
		{ desc = "Toggle line wrap" },
	},
})

-- Comment
keymaps:add_multiple({
	{ "n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" } },
	{ "x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" } },
	{
		"n",
		"gco",
		"o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
		{ desc = "Insert comment below current line" },
	},
	{
		"n",
		"gcO",
		"O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
		{ desc = "Insert comment above current line" },
	},
})

-- Navigation
keymaps:add_multiple({
	{ "n", "]t", vim.cmd.tabnext, { desc = "Next tab", unique = false } },
	{ "n", "[t", vim.cmd.tabprevious, { desc = "Previous tab", unique = false } },
})

-- Search
keymaps:add_multiple({
	{
		"n",
		"n",
		function()
			local ok = pcall(function() vim.cmd("normal! nzz") end)
			if ok then require("hlslens").start() end
		end,
		{ desc = "Next result" },
	},
	{
		"n",
		"N",
		function()
			local ok = pcall(function() vim.cmd("normal! Nzz") end)
			if ok then require("hlslens").start() end
		end,
		{ desc = "Previous result" },
	},
	{
		{ "i", "n", "s" },
		"<Esc>",
		function()
			vim.cmd("noh")
			local luasnip = require("luasnip")
			if luasnip.get_active_snip() then luasnip.unlink_current() end
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

-- Diagnostics
keymaps:add_multiple({
	{ "n", "gl", function() vim.diagnostic.open_float() end, { desc = "Hover diagnostics" } },
	{ "n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "Hover diagnostics" } },
	{
		"n",
		"[e",
		function() vim.diagnostic.jump({ count = -vim.v.count1, severity = "ERROR" }) end,
		{ desc = "Previous error" },
	},
	{
		"n",
		"]e",
		function() vim.diagnostic.jump({ count = vim.v.count1, severity = "ERROR" }) end,
		{ desc = "Next error" },
	},
	{
		"n",
		"[w",
		function() vim.diagnostic.jump({ count = -vim.v.count1, severity = "WARN" }) end,
		{ desc = "Previous warning" },
	},
	{
		"n",
		"]w",
		function() vim.diagnostic.jump({ count = vim.v.count1, severity = "WARN" }) end,
		{ desc = "Next warning" },
	},
})

-- LSP
keymaps:add_multiple({
	{ "n", "grr", false },
	{ "n", "grn", false },
	{ "n", "gri", false },
	{ "n", "grt", false },
	{ "n", "gra", false },
	{
		{ "n", "x" },
		"<leader>la",
		function() vim.lsp.buf.code_action() end,
		{ desc = "LSP code action", lsp = { method = "textDocument/codeAction" }, optional = true },
	},
	{
		"n",
		"<leader>lA",
		function() vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } }) end,
		{ desc = "LSP source action", lsp = { method = "textDocument/codeAction" } },
	},
	{
		"n",
		"<leader>ll",
		function() vim.lsp.codelens.refresh() end,
		{ desc = "LSP CodeLens refresh", lsp = { method = "textDocument/codeLens" } },
	},
	{
		"n",
		"<leader>lL",
		function() vim.lsp.codelens.run() end,
		{ desc = "LSP CodeLens run", lsp = { method = "textDocument/codeLens" } },
	},
	{
		"n",
		"<leader>lf",
		vim.cmd.Format,
		{ desc = "Format buffer", lsp = { method = "textDocument/formatting" } },
	},
	{
		"v",
		"<leader>lf",
		"<CMD>Format<CR>",
		{ desc = "Format buffer", lsp = { method = "textDocument/rangeFormatting" } },
	},
	{
		"n",
		"<leader>lR",
		function() vim.lsp.buf.references() end,
		{ desc = "Search references", lsp = { method = "textDocument/references" } },
	},
	{
		"n",
		"<leader>lr",
		function() vim.lsp.buf.rename() end,
		{ desc = "Rename current symbol", lsp = { method = "textDocument/rename" } },
	},
	{
		"n",
		"<leader>lh",
		function() vim.lsp.buf.signature_help() end,
		{ desc = "Signature help", lsp = { method = "textDocument/signatureHelp" } },
	},
	{
		"n",
		"gK",
		function() vim.lsp.buf.signature_help() end,
		{ desc = "Signature help", lsp = { method = "textDocument/signatureHelp" } },
	},
	{
		"n",
		"<leader>lG",
		function() vim.lsp.buf.workspace_symbol() end,
		{ desc = "Search workspace symbols", lsp = { method = "workspace/symbol" } },
	},
})

return keymaps
