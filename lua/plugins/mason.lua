---@type LazySpec
return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		keys = { { "<Leader>li", vim.cmd.LspInfo, desc = "LSP information" } },
		opts = {},
		init = function() vim.lsp.enable("sourcekit") end,
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
				"astro-language-server",

				-- Bash
				"bash-language-server",
				"shellcheck",
				"shfmt",
				"bash-debug-adapter",

				"clangd",

				-- C#
				"omnisharp",
				"csharpier",
				"netcoredbg",

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
				"golines",

				-- Gradle
				"gradle-language-server",
				"npm-groovy-lint",

				"graphql-language-service-cli",

				-- HTML
				"html-lsp",
				"css-lsp",
				"emmet-language-server",

				-- hyprland
				"hyprls",

				-- json
				"json-lsp",

				"just-lsp",

				-- Lua
				"lua-language-server",
				"stylua",
				"selene",

				"checkmake",

				-- Markdown
				"marksman",
				-- "markdownlint",

				-- nginx
				"nginx-config-formatter",
				"nginx-language-server",

				"prettierd",
				"prisma-language-server",

				-- Python
				"debugpy",
				"basedpyright",
				"mypy",
				"black",
				"isort",

				-- Rust
				"rust-analyzer",
				"codelldb", -- and C

				-- SQL
				"sqlfluff",
				"sqls",

				-- Swift
				"codelldb",

				"tailwindcss-language-server",
				"taplo",

				-- Javascript
				"js-debug-adapter",
				"tsgo",
				"eslint_d",

				-- XML
				"lemminx",

				-- YAML
				"yamllint",
				"yaml-language-server",

				"typos-lsp",
				"tree-sitter-cli",
			},
		},
		init = function()
			vim.schedule(function() require("mason-tool-installer").run_on_start() end)
		end,
	},
}
