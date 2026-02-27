vim.filetype.add({
	extension = {
		env = "dotenv",
		podspec = "ruby",
		tmux = "tmux",
		gitconfig = "gitconfig",
	},
	filename = {
		[".env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
		[".eslintrc.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
		[".sqlfluff"] = "toml",
		["Podfile"] = "ruby",
		["dot-zshrc"] = "zsh",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})

return {
	javascript = {
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"jsx",
	},
}
