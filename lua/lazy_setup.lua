require("lazy").setup({
	{
		"AstroNvim/AstroNvim",
		version = "^5", -- Remove version tracking to elect for nightly AstroNvim
		import = "astronvim.plugins",
		opts = { -- AstroNvim options must be set here with the `import` key
			mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
			-- spell-checker:disable-line
			maplocalleader = ",", -- This ensures the localleader key must be configured before Lazy is set up
			icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
			pin_plugins = nil, -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
			update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
		},
	},
	{ import = "community" },
	{ import = "plugins" },
} --[[@as LazySpec]], {
	-- Configure any other `lazy.nvim` configuration options here
	install = { colorscheme = { require("colorscheme"), "astrotheme", "habamax" } }, -- spell-checker:disable-line
	ui = {
		backdrop = 100,
		border = require("utils.constants").border_type,
	},
	concurrency = 20,
	performance = {
		rtp = {
			-- disable some rtp plugins, add more to your liking
			disabled_plugins = {
				"gzip",
				"netrwPlugin", -- spell-checker:disable-line
				"tarPlugin",
				"tohtml", -- spell-checker:disable-line
				"zipPlugin",
			},
		},
	},
} --[[@as LazyConfig]])
