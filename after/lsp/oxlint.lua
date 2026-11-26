-- Load the upstream hook without recursively resolving this server's config.
local defaults = dofile(vim.api.nvim_get_runtime_file("lsp/oxlint.lua", false)[1])

---@type vim.lsp.Config | { settings?: lsp.oxlint }
return {
	workspace_required = false,
	settings = { run = "onSave" },
	before_init = function(params, config)
		if defaults.before_init then defaults.before_init(params, config) end

		-- Oxlint's onSave setting only applies to push diagnostics.
		params.capabilities.textDocument.diagnostic = nil
		params.capabilities.workspace.diagnostics = nil
	end,
	root_dir = function(buffer, on_dir)
		local filename = vim.api.nvim_buf_get_name(buffer)
		local start_path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
		if not start_path then return end

		on_dir(
			vim.fs.root(start_path, { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", ".git" })
				or start_path
		)
	end,
}
