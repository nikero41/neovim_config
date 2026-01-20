---@type LazySpec
return {
	{
		"mason-org/mason.nvim",
		---@module "mason"
		---@type MasonSettings
		opts = {
			ui = { border = "rounded" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				-- language servers
				"gradle-language-server",
				"graphql-language-service-cli",
				"rust-analyzer",

				-- none-ls
				"checkmake",
				"clang-format",
				"cspell",
				"eslint_d",
				"golines",
				"markdownlint",
				"mypy",
				"npm-groovy-lint",
				"pylint",
				"stylelint",
				"sql-formatter",
				"yamllint",

				-- install any other package
				"tree-sitter-cli",
			},
			auto_update = true,
		},
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = { handlers = { function() end } },
	},
}
