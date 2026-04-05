require("options")
require("commands"):setup()
require("autocmds"):setup()

local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local out = vim
		.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})
		:wait()
	if out.code ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out.stderr, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local lazy_loaded, lazy = pcall(require, "lazy")
if not lazy_loaded then
	vim.api.nvim_echo({
		{ ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" },
		{ "Press any key to exit...", "MoreMsg" },
	}, true, {})
	vim.fn.getchar()
	vim.cmd.quit()
end

lazy.setup({
	spec = {
		{ import = "plugins/snacks" },
		{ import = "plugins" },
		{ import = "plugins/language" },
	},
	defaults = { lazy = true },
	install = { colorscheme = { vim.g.colorscheme } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = { border = vim.o.winborder },
})

require("keymaps"):setup()
require("highlights"):setup()
require("filetypes"):setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
