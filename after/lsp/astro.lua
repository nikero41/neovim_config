---@type vim.lsp.Config | { settings?: lsp.astro }
return {
	init_options = {
		typescript = {
			serverPath = "tsgo",
		},
	},
}
