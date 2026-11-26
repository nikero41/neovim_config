---@type vim.lsp.Config | { settings?: lsp.gopls }
return {
	settings = {
		gopls = {
			analyses = {
				ST1003 = true,
				fieldalignment = false,
				fillreturns = true,
				nilness = true,
				nonewvars = true,
				shadow = true,
				unreachable = true,
				unusedparams = true,
				unusedwrite = true,
			},
			codelenses = {
				generate = true, -- show the `go generate` lens.
				regenerate_cgo = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				ignoredError = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			buildFlags = { "-tags", "integration" },
			completeUnimported = true,
			diagnosticsDelay = "500ms",
			gofumpt = true,
			matcher = "Fuzzy",
			semanticTokens = true,
			staticcheck = true,
			symbolMatcher = "Fuzzy",
			usePlaceholders = true,
			vulncheck = "Imports",
		},
	},
}
