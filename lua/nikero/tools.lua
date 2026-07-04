local function default_config_path(filename)
	local default_config = vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", filename)
	assert(vim.uv.fs_stat(default_config))
	return default_config
end

local project_dir_cache = {}

local function project_paths(buffer)
	local filename = vim.api.nvim_buf_get_name(buffer or 0)
	local start_path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
	if not start_path then return nil, nil end

	start_path = vim.fs.normalize(start_path)

	local project_dir = project_dir_cache[start_path]
	if not project_dir then
		project_dir = vim.fs.normalize(vim.fs.root(start_path, ".git") or vim.uv.cwd() or start_path)
		project_dir_cache[start_path] = project_dir
	end

	return start_path, project_dir
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
---| "markdownlint"

---@class Tools
---@field configs table<ToolConfigName, ToolConfig>
---@field package_json_has_key fun(self: Tools, key: string): boolean
---@field find_config_file fun(self: Tools, names: string[], opts?: { bufnr?: integer, stop?: string }): string|nil
---@field get_js_tools fun(self: Tools, buffer: integer): { linter: ("oxlint"|"eslint")[], formatter: ("oxfmt"|"prettier")[] }
---@field _js_tools_cache table<string, { linter: ("oxlint"|"eslint")[], formatter: ("oxfmt"|"prettier")[] }>
local Tools = {
	_js_tools_cache = {},
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
		markdownlint = {
			".markdownlint.json",
			".markdownlint.jsonc",
			".markdownlint.yaml",
			".markdownlint.yml",
			".markdownlintrc",
			".markdownlintrc.json",
			".markdownlintrc.yaml",
			".markdownlintrc.yml",
			default_config_path = default_config_path(".markdownlint.jsonc"),
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

	local start_path, project_dir = project_paths(opts.bufnr)
	if not start_path then return nil end
	local stop_path = opts.stop or project_dir or start_path

	local config_path = vim.fs.find(names, {
		path = start_path,
		stop = vim.fs.normalize(stop_path),
		upward = true,
		type = "file",
		limit = 1,
	})[1]

	if not config_path then
		config_path = vim
			.iter(ipairs(names))
			:map(function(_, name) return vim.fs.joinpath(stop_path, name) end)
			:find(function(path) return vim.uv.fs_stat(path) end)
	end

	return config_path
end

function Tools:get_js_tools(buffer)
	local _, project_dir = project_paths(buffer)
	if not project_dir then return { linter = { "oxlint" }, formatter = { "oxfmt" } } end

	local cached = self._js_tools_cache[project_dir]
	if cached then return cached end

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

	local result = { linter = linter, formatter = formatter }
	self._js_tools_cache[project_dir] = result
	return result
end

return Tools
