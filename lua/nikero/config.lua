---@class Config
---@field transparency boolean
---@field hide_code_lens_ft string[] Filetypes where code lens should be disabled
---@field get_sql_connections fun(self: Config): SqlsConnection[]
local Config = {
	transparency = false,
	hide_code_lens_ft = { "lua", "rust" },
}

function Config:get_sql_connections()
	local ok, sql_connections = pcall(require, "nikero.config.sql_connections")
	if not ok then
		vim.notify("SQL connection file not found", nil, { title = "SQL" })
		return {}
	end
	return sql_connections
end

return Config
