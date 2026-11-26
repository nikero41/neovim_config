---@type vim.lsp.Config
return {
	root_markers = { ".rumdl.toml", "rumdl.toml", ".git" },
	cmd_env = { XDG_CONFIG_HOME = vim.fs.joinpath(vim.fn.stdpath("config"), "config_files") },
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
