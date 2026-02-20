---@type LazySpec
return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			opts.ensure_installed = require("astrocore").extend_tbl(opts.ensure_installed, {
				-- language servers
				"gradle-language-server",
				"graphql-language-service-cli",
				"typos-lsp",
				"rust-analyzer",

				-- none-ls
				"checkmake",
				"clang-format",
				"eslint_d",
				"emmet-language-server",
				"golines",
				"golangci-lint-langserver",
				"markdownlint",
				"mypy",
				"npm-groovy-lint",
				"pylint",
				"stylelint",
				"sql-formatter",
				"tsgo",
				"yamllint",

				-- install any other package
				"tree-sitter-cli",
			})

			require("nikero.utils"):remove_list_value(opts.ensure_installed, "vtsls")
			require("nikero.utils"):remove_list_value(opts.ensure_installed, "emmet-ls")

			return opts
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = { handlers = { function() end } },
	},
}
