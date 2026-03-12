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
		ft = "rust",
		init = function()
			vim.lsp.enable("rust_analyzer", false)
			vim.g.rustaceanvim = { dap = { load_rust_types = true } }
		end,
	},
		},
		init = function() vim.lsp.enable("rust_analyzer", false) end,
		config = function(_, opts) vim.g.rustaceanvim = opts end,
	},
}
