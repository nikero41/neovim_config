--@alias SqlsDriver
---| "mysql"
---| "postgresql"
---| "sqlite3"
---| "mssql"
---| "h2"

--@class SqlsSshConfig
---@field host? string
---@field port? integer
---@field user? string
---@field passwd? string
---@field privateKey? string

--@class SqlsConnection
---@field alias? string Connection alias name.
---@field driver SqlsDriver
---@field dataSourceName? string Data source name.
---@field proto? "tcp"|"udp"|"unix"
---@field user? string
---@field passwd? string
---@field host? string
---@field port? integer
---@field path? string Unix socket path.
---@field dbName? string Database name.
---@field params? table<string, string>
---@field sshConfig? SqlsSshConfig

---@type SqlsConnection[]
local sql_connections = {}

return sql_connections
