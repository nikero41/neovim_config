---@type vim.lsp.Config
return {
	settings = {
		["csharp|code_lens"] = {
			dotnet_enable_tests_code_lens = true,
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
		},
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_types = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
		},
	},
}
