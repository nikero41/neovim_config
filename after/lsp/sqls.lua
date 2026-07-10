---@type vim.lsp.Config | { settings?: lsp.sqls }
return {
	settings = {
		sqls = { connections = require("nikero.config"):get_sql_connections() },
	},
}
