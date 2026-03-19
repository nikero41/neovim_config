---@type vim.lsp.Config | { settings?: lsp.rust_analyzer }
return {
	settings = {
		["rust-analyzer"] = {
			files = {
				excludeDirs = {
					".direnv",
					".git",
					"target",
				},
			},
			check = {
				command = "clippy",
				extraArgs = { "--no-deps" },
			},
		},
	},
}
