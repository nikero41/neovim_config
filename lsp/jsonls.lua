---@type vim.lsp.Config | { settings?: lsp.jsonls }
return {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}
