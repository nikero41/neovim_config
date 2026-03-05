---TODO: should use nvim-lint(?)
---@type vim.lsp.Config
return {
	nit_options = {
		command = {
			"golangci-lint",
			"run",
			"--output.json.path",
			"stdout",
			"--show-stats=false",
			"--issues-exit-code=1",
		},
	},
}
