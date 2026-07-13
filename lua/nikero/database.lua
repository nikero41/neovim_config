---@alias Dialect "postgres" | "mysql" | "sqlite" | "tsql"

---@class DatabaseConfig
---@field dialect Dialect
---@field set_dialect fun(self: DatabaseConfig, dialect: Dialect)
local DatabaseConfig = {
	dialect = "postgres",
}

function DatabaseConfig:set_dialect(dialect) self.dialect = dialect end

return DatabaseConfig
