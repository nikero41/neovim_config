---@type LazySpec
return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		keys = { { "<Leader>li", vim.cmd.LspInfo, desc = "LSP information" } },
		opts = {},
	},
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		build = ":MasonUpdate",
		---@type MasonSettings
		opts = {
			ui = {
				border = vim.o.winborder,
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = {
			"MasonToolsInstall",
			"MasonToolsInstallSync",
			"MasonToolsUpdate",
			"MasonToolsUpdateSync",
			"MasonToolsClean",
		},
		---@type MasonToolInstallerSettings
		opts = {
			run_on_start = true,
			auto_update = true,
			ensure_installed = {
				-- Astro
				"astro-language-server",
				-- Bash
				"bash-language-server",
				"shellcheck",
				"shfmt",
				"bash-debug-adapter",
				-- Docker
				"docker-language-server",
				"hadolint",
				-- Go
				"delve",
				"gopls",
				"gomodifytags",
				"gotests",
				"iferr",
				"impl",
				"goimports",
				"golangci-lint-langserver",
				-- HTML
				"html-lsp",
				"css-lsp",
				"emmet-language-server",
				-- hyprland
				"hyprls",
				-- json
				"json-lsp",

				-- language servers
				-- "gradle-language-server",
				-- "graphql-language-service-cli",
				-- "typos-lsp",
				-- "rust-analyzer",
				--
				"lua-language-server",
				-- -- none-ls
				-- "checkmake",
				-- "clang-format",
				-- "eslint_d",
				-- "emmet-language-server",
				-- "golines",
				-- "golangci-lint-langserver",
				-- "markdownlint",
				-- "mypy",
				-- "npm-groovy-lint",
				-- "pylint",
				-- "stylelint",
				-- "sql-formatter",
				"tsgo",
				-- "yamllint",

				-- install any other package
				"tree-sitter-cli",
			},
		},
		init = function()
			vim.schedule(function() require("mason-tool-installer").run_on_start() end)
		end,
	},
}
