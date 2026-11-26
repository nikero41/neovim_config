---@class Config
---@field transparency boolean
---@field builtin_syntax_filetypes string[] Filetypes using Neovim's built-in syntax highlighting
---@field show_code_lens_ft string[] Filetypes where code lens should be enabled
---@field get_sql_connections fun(self: Config): SqlsConnection[]
local Config = {
	transparency = false,
	builtin_syntax_filetypes = { "tmux" },
	show_code_lens_ft = { "go" },
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
