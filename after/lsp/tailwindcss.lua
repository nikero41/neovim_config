---@type vim.lsp.Config | { settings?: lsp.tailwindcss }
return {
	settings = {
		tailwindCSS = {
			emmetCompletions = true,
			includeLanguages = {
				rust = "html",
			},
			experimental = { classRegex = { 'class: "(.*)"' } },
		},
	},
}
