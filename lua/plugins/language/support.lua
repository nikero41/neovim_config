---@type LazySpec
return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			{
				"neovim/nvim-lspconfig",
				config = function()
					local extra_filetypes = {
						html = { "templ" },
						emmet_language_server = { "templ" },
						tailwindcss = { "templ" },
					}

					vim
						.iter(extra_filetypes)
						:enumerate()
						:filter(function(server) return not not vim.lsp.config[server] end)
						:each(function(server)
							local config = vim.lsp.config[server] or {}
							vim.lsp.config(server, {
								filetypes = vim.list.unique(
									vim.tbl_extend("force", config.filetypes or {}, extra_filetypes[server])
								),
							})
						end)
				end,
			},
		},
		---@type MasonLspconfigSettings
		opts = {
			automatic_enable = {
				exclude = { "rust_analyzer" },
			},
		},
	},
	{
		"mrjones2014/codesettings.nvim",
		lazy = false, -- this plugin since it already lazy loads
		---@type CodesettingsConfigOverrides
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
				"templ",
				"prettier", -- for templ

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
