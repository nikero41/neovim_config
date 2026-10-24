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
			---@module "rustaceanvim"
			---@type rustaceanvim.Opts
			vim.g.rustaceanvim = {
				server = {
					standalone = false,
					---@type lsp.rust_analyzer
					default_settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							procMacro = { enable = true },
							files = {
								excludeDirs = { ".direnv", ".git", "target" },
							},
							check = {
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
						},
					},
				},
			}
		end,
	},
}
