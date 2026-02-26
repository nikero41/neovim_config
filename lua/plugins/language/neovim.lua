---@type LazySpec
return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts_extend = { "library" },
		opts = {
			---@type lazydev.Library.spec[]
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "lazy.nvim", words = { "Lazy" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
			integrations = { lspconfig = true },
		},
		specs = {
			{
				"saghen/blink.cmp",
				---@module 'blink.cmp'
				---@type blink.cmp.Config
				opts = {
					sources = {
						per_filetype = {
							lua = { "lazydev", inherit_defaults = true },
						},
						providers = {
							lazydev = {
								name = "LazyDev",
								module = "lazydev.integrations.blink",
								score_offset = 100,
							},
						},
					},
				},
			},
		},
	},
}
