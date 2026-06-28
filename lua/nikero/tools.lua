local function default_config_path(filename)
	local default_config = vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", filename)
	assert(vim.uv.fs_stat(default_config))
	return default_config
end

---@class ToolConfig: string[]
---@field default_config_path string?

---@alias ToolConfigName
---| "prettier"
---| "eslint"
---| "stylelint"
---| "stylua"
---| "selene"
---| "oxlint"
---| "oxfmt"
---| "sqlfluff"
---| "yamllint"

---@class Tools
---@field configs table<ToolConfigName, ToolConfig>
---@field default_config_path fun(self: Tools, filename: string): string
---@field package_json_has_key fun(self: Tools, key: string): boolean
---@field find_config_file fun(self: Tools, names: string[], opts?: { bufnr?: integer, stop?: string }): string|nil
---@field get_default_config fun(self: Tools, name: string): string|nil
---@field get_js_tools fun(self: Tools, buffer: integer): { linter: ("oxlint"|"eslint")[], formatter: ("oxfmt"|"prettier")[] }
local Tools = {
	configs = {
		prettier = {
			".prettierrc",
			".prettierrc.cjs",
			".prettierrc.cts",
			".prettierrc.js",
			".prettierrc.json",
			".prettierrc.json5",
			".prettierrc.mjs",
			".prettierrc.mts",
			".prettierrc.toml",
			".prettierrc.ts",
			".prettierrc.yaml",
			".prettierrc.yml",
			"prettier.config.cjs",
			"prettier.config.js",
			"prettier.config.mjs",
			"prettier.config.mts",
			"prettier.config.ts",
			default_config_path = default_config_path("prettier.config.js"),
		},
		eslint = {
			-- ESLint <=8 (Deprecated)
			".eslintignore",
			".eslintrc",
			".eslintrc.cjs",
			".eslintrc.js",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
			-- ESLint >=9
			"eslint.config.cjs",
			"eslint.config.cts",
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.mts",
			"eslint.config.ts",
		},
		stylelint = {
			".stylelintrc.js",
			"stylelint.config.js",
			".stylelintrc.mjs",
			"stylelint.config.mjs",
			".stylelintrc.cjs",
			"stylelint.config.cjs",
			".stylelintrc.json",
			".stylelintrc.yml",
			".stylelintrc.yaml",
			default_config_path = default_config_path("stylelint.config.js"),
		},
		stylua = {
			".stylua.toml",
			"stylua.toml",
			".editorconfig",
			default_config_path = default_config_path(".stylua.toml"),
		},
		selene = {
			".selene.toml",
			"selene.toml",
			default_config_path = default_config_path(".selene.toml"),
		},
		oxlint = {
			".oxlintrc.json",
			".oxlintrc.jsonc",
			"oxlint.config.ts",
		},
		oxfmt = {
			".oxfmtrc.json",
			".oxfmtrc.jsonc",
			"oxfmt.config.ts",
			default_config_path = default_config_path("oxfmt.config.ts"),
		},
		sqlfluff = {
			"setup.cfg",
			"tox.ini",
			"pep8.ini",
			".sqlfluff",
			"pyproject.toml",
			default_config_path = default_config_path(".sqlfluff"),
		},
		yamllint = {
			default_config_path = default_config_path(".yamllint.yaml"),
		},
	},
}

function Tools:package_json_has_key(key)
	local package_json_path = self:find_config_file({ "package.json" })
	if not package_json_path then return false end

	local file = io.open(package_json_path, "r")
	if not file then return false end

	local content = file:read("*all")
	file:close()

	local json_parsed, json = pcall(vim.fn.json_decode, content)
	if not json_parsed or type(json) ~= "table" then return false end

	return json[key] ~= nil
end

function Tools:find_config_file(names, opts)
	opts = opts or {}

	local filename = vim.api.nvim_buf_get_name(opts.bufnr or 0)
	local start_path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
	if not start_path then return nil end

	local stop_path = opts.stop or vim.fs.root(start_path, ".git") or vim.uv.cwd() or start_path

	local config_path = vim.fs.find(names, {
		path = vim.fs.normalize(start_path),
		stop = vim.fs.normalize(stop_path),
		upward = true,
		type = "file",
		limit = 1,
	})[1]

	if config_path ~= nil then
		config_path = vim
			.iter(names)
			:map(function(name) return vim.fs.joinpath(stop_path, name) end)
			:find(function(path) return vim.uv.fs_stat(path) end)
	end

	return config_path
end

function Tools:get_default_config(tool_name)
	local config = self.configs[tool_name]
	local has_project_config = self:find_config_file(config)
	if has_project_config or not config.default_config_path then return nil end
	return config.default_config_path
end

function Tools:get_js_tools(buffer)
	local linter = {}
	local formatter = {}

	local has_oxlint = self:find_config_file(self.configs.oxlint, { bufnr = buffer }) ~= nil
	local has_eslint = self:find_config_file(self.configs.eslint, { bufnr = buffer }) ~= nil

	if has_oxlint or not has_eslint then linter = { "oxlint" } end
	if has_eslint then vim.list_extend(linter, { "eslint" }) end

	local has_oxfmt = self:find_config_file(self.configs.oxfmt, { bufnr = buffer }) ~= nil
	local has_prettier = self:find_config_file(self.configs.prettier, { bufnr = buffer }) ~= nil

	if has_oxfmt or not has_prettier then formatter = { "oxfmt" } end
	if not has_oxfmt and has_prettier then vim.list_extend(formatter, { "prettier" }) end

	return { linter = linter, formatter = formatter }
end

return Tools
