---@type LazySpec
return {
	{
		"saecki/crates.nvim",
		event = "BufRead Cargo.toml",
		opts = {
			completion = {
				crates = { enabled = true },
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^8",
		lazy = false, -- This plugin is already lazy
		ft = "rust",
		opts = {
			tools = { enable_clippy = false },
			dap = { load_rust_types = true },
		},
		init = function() vim.lsp.enable("rust_analyzer", false) end,
		config = function(_, opts) vim.g.rustaceanvim = opts end,
	},
}
