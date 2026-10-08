---@type vim.lsp.Config | { settings?: lsp.oxlint }
return {
	workspace_required = false,
	settings = { run = "onSave" },
	before_init = function(params)
		params.capabilities.textDocument.diagnostic = nil
		params.capabilities.workspace.diagnostics = nil
	end,
	root_dir = function(buffer, on_dir)
		local filename = vim.api.nvim_buf_get_name(buffer)
		local start_path = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
		if not start_path then return end

		on_dir(
			vim.fs.root(start_path, { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts", ".git" })
				or start_path
		)
	end,
}
