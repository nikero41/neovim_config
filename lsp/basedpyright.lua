---@type vim.lsp.Config
return {
	before_init = function(_, config)
		if not config.settings then config.settings = {} end
		if not config.settings.python then config.settings.python = {} end
		config.settings.python.pythonPath = vim.fn.exepath("python")
	end,
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "basic",
				autoImportCompletions = true,
				diagnosticSeverityOverrides = {
					reportUnusedImport = "information",
					reportUnusedFunction = "information",
					reportUnusedVariable = "information",
					reportGeneralTypeIssues = "none",
					reportOptionalMemberAccess = "none",
					reportOptionalSubscript = "none",
					reportPrivateImportUsage = "none",
				},
			},
		},
	},
}
