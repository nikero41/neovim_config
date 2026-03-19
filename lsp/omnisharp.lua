---@type vim.lsp.Config | { settings?: lsp.omnisharp }
return {
	handlers = {
		["textDocument/definition"] = function(...)
			require("omnisharp_extended").definition_handler(...)
		end,
		["textDocument/typeDefinition"] = function(...)
			require("omnisharp_extended").type_definition_handler(...)
		end,
		["textDocument/references"] = function(...)
			require("omnisharp_extended").references_handler(...)
		end,
		["textDocument/implementation"] = function(...)
			require("omnisharp_extended").implementation_handler(...)
		end,
	},
}
