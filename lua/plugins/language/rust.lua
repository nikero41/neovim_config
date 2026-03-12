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
	{
		"cordx56/rustowl",
		build = "cargo install rustowl",
		ft = "rust",
		keys = {
			{
				"<leader>rl",
				function()
					require("rustowl").toggle()
					vim.notify(
						"Lifetimes enabled" .. (require("rustowl").is_enabled() and "enabled" or "disabled"),
						vim.log.levels.INFO({ title = "Rust" })
					)
				end,
				desc = "Toggle Rust lifetimes",
				ft = "rust",
			},
		},
		opts = {},
		init = function()
			local config = require("rustowl.config").client
			vim.lsp.config("rustowl", config)
		end,
	},
}
