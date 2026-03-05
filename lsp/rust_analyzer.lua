---@type vim.lsp.Config
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
