---@class Tools
---@field configs table<string, string[]>
---@field default_config_path fun(self: Tools, filename: string): string
---@field package_json_has_key fun(self: Tools, key: string): boolean
---@field find_config_file fun(self: Tools, names: string[], opts?: { bufnr?: integer, stop?: string }): string|nil
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
		},
		stylua = {
			".stylua.toml",
			"stylua.toml",
			".editorconfig",
		},
		selene = {
			".selene.toml",
			"selene.toml",
		},
		sqlfluff = {
			"setup.cfg",
			"tox.ini",
			"pep8.ini",
			".sqlfluff",
			"pyproject.toml",
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

	if not config_path then
		config_path = vim
			.iter(names)
			:map(function(name) return vim.fs.joinpath(stop_path, name) end)
			:find(function(path) return vim.uv.fs_stat(path) end)
	end

	return config_path
end

function Tools:default_config_path(filename)
	local default_config = vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", filename)
	assert(vim.uv.fs_stat(default_config))
	return default_config
end

return Tools
