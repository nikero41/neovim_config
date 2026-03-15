---@type LazySpec
return {
	{
		"saecki/crates.nvim",
		event = "BufRead Cargo.toml",
		---@module "crates"
		---@type crates.UserConfig
		opts = {
			completion = { crates = { enabled = true } },
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			popup = { show_version_date = true },
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^8",
		ft = "rust",
		init = function()
			vim.lsp.enable("rust_analyzer", false)
			---@module "rustaceanvim"
			---@type rustaceanvim.Opts
			vim.g.rustaceanvim = {
				tools = {
					hover_actions = { auto_focus = true },
					inlay_hints = {
						auto = true,
						show_parameter_hints = true,
					},
				},
				server = {
					standalone = false,
					default_settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							procMacro = { enable = true },
						},
					},
				},
			}
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
						"Lifetimes " .. (require("rustowl").is_enabled() and "enabled" or "disabled"),
						vim.log.levels.INFO,
						{ title = "Rust" }
					)
				end,
				desc = "Toggle Rust lifetimes",
				ft = "rust",
			},
		},
		---@type rustowl.Config
		opts = {},
		---@param opts rustowl.Config
		config = function(_, opts)
			local config = require("rustowl.config").client
			vim.lsp.config("rustowl", config)
			require("rustowl").setup(opts)
		end,
	},
}
