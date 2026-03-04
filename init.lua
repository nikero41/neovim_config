require("options")
require("autocmds"):setup()

local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
require("keymaps"):setup()
require("highlights"):setup()
require("filetypes"):setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
