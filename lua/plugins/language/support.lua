---@type LazySpec
return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			{
				"neovim/nvim-lspconfig",
				config = function()
					vim.lsp.enable("sourcekit")
					vim.lsp.config("*", {
						---@param client vim.lsp.Client The LSP client details when attaching
						---@param buffer integer The buffer that the LSP client is attaching to
						on_attach = function(client, buffer)
							if client:supports_method("textDocument/codeLens", buffer) then
								vim.lsp.codelens.refresh({ bufnr = buffer })
							end
							vim.lsp.inlay_hint.enable()
						end,
					})
				end,
			},
		},
		keys = { { "<leader>li", vim.cmd.LspInfo, desc = "LSP information" } },
		opts = {
			automatic_enable = {
				exclude = { "rust_analyzer" },
			},
		},
	},
	{
		"mrjones2014/codesettings.nvim",
		lazy = false, -- this plugin since it already lazy loads
		opts = {
			loader_extensions = {
				"codesettings.extensions.vscode",
				"codesettings.extensions.env",
				"codesettings.extensions.neoconf",
			},
		},
	},
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		build = ":MasonUpdate",
		---@module 'mason'
		---@type MasonSettings
		opts = {
			ui = {
				border = vim.o.winborder,
				icons = {
					package_installed = require("icons").status.check,
					package_pending = require("icons").status.working .. " ",
					package_uninstalled = require("icons").tools.package,
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

				-- C/C++
				"clangd",
				"clang-format",

				-- C#
				"omnisharp",
				"csharpier",
				"netcoredbg",

				-- Docker
				"docker-language-server",
				"hadolint",

				"dotenv-linter",

				-- Go
				"delve",
				"gopls",
				"gomodifytags",
				"gotests",
				"iferr",
				"impl",
				"goimports",
				"golangci-lint",
				"golines",

				-- Gradle
				"gradle-language-server",
				"npm-groovy-lint",

				"graphql-language-service-cli",

				-- HTML - CSS
				"html-lsp",
				"css-lsp",
				"emmet-language-server",
				"stylelint",

				-- hyprland
				"hyprls",

				-- json
				"json-lsp",
				"jsonlint",

				"just-lsp",

				-- Lua
				"lua-language-server",
				"stylua",
				"selene",

				"checkmake",

				-- Markdown
				"marksman",
				"markdownlint",

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
		init = function() vim.schedule(require("mason-tool-installer").run_on_start) end,
	},
}
