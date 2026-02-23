---@class Tsgo
---@field ignore_codes table<number,string>
---@field setup fun(self: Tsgo, opts: vim.lsp.Config)
---@field format_errors fun(self: Tsgo, diagnostics: table): table
---@field format_hover fun(self: Tsgo, input: string): string
local Tsgo = {
	ignore_codes = {
		[80001] = "File is a CommonJS module; it may be converted to an ES module.",
	},
}

function Tsgo:setup(opts)
	vim.lsp.config(
		"tsgo",
		require("astrocore").extend_tbl(opts, {
			cmd = function(dispatchers, config)
				local cmd = "tsgo"
				local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/tsgo"
				if local_cmd and vim.fn.executable(local_cmd) == 1 then cmd = local_cmd end
				return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
			end,
			filetypes = require("utils.constants").filetype.javascript,
			root_dir = function(bufnr, on_dir)
				local root_markers =
					{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
				root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
					or vim.list_extend(root_markers, { ".git" })

				local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
				local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
				local project_root = vim.fs.root(bufnr, root_markers)
				if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then return end
				if deno_root and (not project_root or #deno_root >= #project_root) then return end
				on_dir(project_root or vim.fn.getcwd())
			end,
		})
	)
end

function Tsgo:format_errors(diagnostics)
	local idx = 1
	while idx <= #diagnostics do
		local entry = diagnostics[idx]

		local formatter = require("format-ts-errors")[entry.code]
		entry.message = formatter and formatter(entry.message) or entry.message

		-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
		if self.ignore_codes[entry.code] then
			table.remove(diagnostics, idx)
		else
			idx = idx + 1
		end
	end

	return diagnostics
end

local WIDTH = 30
function Tsgo:format_hover(input)
	local tag, code = string.match(input, "^(%(%a*%) )(.*)")
	if not code then code = input end

	local command = string.format(
		'(out=$(echo "%s" | prettierd --parser=typescript --no-config --cache --print-width=%s file) && printf \'%%s\' "$out")',
		string.gsub(code, '"', '\\"'),
		WIDTH
	)

	local handle, err = io.popen(command, "r")
	if not handle then return input end

	local result = handle:read("*a")
	handle:close()
	if #result == 0 or err then return input end

	if tag then result = tag .. result end

	return result
end

return Tsgo
