require("options")
require("autocmds")
require("keymaps")

local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

if not pcall(require, "lazy") then
	vim.api.nvim_echo(
		{ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
		true,
		{}
	)
	vim.fn.getchar()
	vim.cmd.quit()
end

require("lazy").setup({
	-- -- LSP Plugins
	-- {
	-- 				-- The following two autocommands are used to highlight references of the
	-- 				-- word under your cursor when your cursor rests there for a little while.
	-- 				--    See `:help CursorHold` for information about when this is executed
	-- 				--
	-- 				-- When you move your cursor, the highlights will be cleared (the second autocommand).
	-- 				local client = vim.lsp.get_client_by_id(event.data.client_id)
	-- 				if client and client:supports_method("textDocument/documentHighlight", event.buf) then
	-- 					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
	-- 					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	-- 						buffer = event.buf,
	-- 						group = highlight_augroup,
	-- 						callback = vim.lsp.buf.document_highlight,
	-- 					})
	--
	-- 					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	-- 						buffer = event.buf,
	-- 						group = highlight_augroup,
	-- 						callback = vim.lsp.buf.clear_references,
	-- 					})
	--
	-- 					vim.api.nvim_create_autocmd("LspDetach", {
	-- 						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
	-- 						callback = function(event2)
	-- 							vim.lsp.buf.clear_references()
	-- 							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
	-- 						end,
	-- 					})
	-- 				end
	-- 			end,
	-- 		})
	spec = {
		{ import = "plugins/snacks" },
		{ import = "plugins" },
		{ import = "plugins/language" },
	},
	defaults = { lazy = true },
	install = { colorscheme = { require("colorscheme") } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = { border = vim.o.winborder },
})

vim.cmd.colorscheme(require("colorscheme"))
require("highlights")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
