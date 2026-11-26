---@type vim.lsp.Config | { settings?: lsp.tailwindcss }
return {
	settings = {
		tailwindCSS = {
			emmetCompletions = true,
			classFunctions = { "cn", "clsx", "cva", "twMerge" },
			includeLanguages = {
				rust = "html",
			},
			experimental = {
				classRegex = {
					[=[class: "(.*)"]=],
					{ [=[tw_merge!\s*\(([^)]*)\)]=], [=["([^"]*)"]=] }, -- tw_merge! (Rust)
					[=[#\[tw\([^)]*class\s*=\s*"([^"]*)"[^)]*\)\]]=], -- tw_merge - #[tw()] (Rust)
				},
			},
		},
	},
}
