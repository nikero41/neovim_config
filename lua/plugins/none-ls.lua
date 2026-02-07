---@type LazySpec
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"davidmh/cspell.nvim",
	},
	opts = function(_, opts)
		local none_ls = require("null-ls")
		local utils = require("null-ls.utils").make_conditional_utils()

		opts.sources = require("astrocore").extend_tbl(opts.sources, {
			-- Code Actions
			require("cspell").code_actions,
			require("none-ls.code_actions.eslint_d"),
			none_ls.builtins.code_actions.refactoring.with({
				extra_filetypes = require("utils.constants").filetype.typescript,
			}),

			-- Diagnostics
			none_ls.builtins.diagnostics.checkmake,
			require("cspell").diagnostics.with({
				disabled_filetypes = { "dotenv" },
			}),
			none_ls.builtins.diagnostics.dotenv_linter.with({ filetype = { "dotenv" } }),
			require("none-ls.diagnostics.eslint_d"),
			none_ls.builtins.diagnostics.hadolint, -- Linter for Docker
			none_ls.builtins.diagnostics.ktlint, -- Linter for Kotlin
			none_ls.builtins.diagnostics.markdownlint,
			none_ls.builtins.diagnostics.npm_groovy_lint,
			none_ls.builtins.diagnostics.mypy,
			none_ls.builtins.diagnostics.pylint,
			none_ls.builtins.diagnostics.selene.with({
				extra_args = function()
					local has_project_config = utils.root_has_file({ ".selene.toml", "selene.toml" })
					if has_project_config then return nil end
					return {
						"--config",
						vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".selene.toml"),
					}
				end,
			}), -- Linter for Lua
			none_ls.builtins.diagnostics.stylelint.with({
				extra_args = function()
					local has_project_config = utils.root_has_file({
						".stylelintrc.js",
						"stylelint.config.js",
						".stylelintrc.mjs",
						"stylelint.config.mjs",
						".stylelintrc.cjs",
						"stylelint.config.cjs",
						".stylelintrc.json",
						".stylelintrc.yml",
						".stylelintrc.yaml",
					}) or require("utils.helpers"):check_json_key_exists(
						vim.fs.joinpath(vim.uv.cwd(), "package.json"),
						"stylelint"
					)
					if has_project_config then return nil end
					return {
						"--config",
						vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".stylelintrc.json"),
					}
				end,
			}),
			none_ls.builtins.diagnostics.sqlfluff.with({
				extra_args = function()
					local args = { "--dialect", "postgres" }
					local has_project_config = utils.root_has_file({
						"setup.cfg",
						"tox.ini",
						"pep8.ini",
						".sqlfluff",
						"pyproject.toml",
					})
					if has_project_config then return args end
					return vim.list_extend(args, {
						"--config",
						vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".sqlfluff"),
					})
				end,
			}),
			none_ls.builtins.diagnostics.yamllint.with({
				env = {
					YAMLLINT_CONFIG_FILE = vim.fs.joinpath(
						vim.fn.stdpath("config"),
						"config_files",
						".yamllint.yaml"
					),
				},
			}),
			none_ls.builtins.diagnostics.zsh,

			-- Formatting
			none_ls.builtins.formatting.black, -- Formatter for Python
			none_ls.builtins.formatting.clang_format,
			require("none-ls.formatting.eslint_d"),
			none_ls.builtins.formatting.golines.with({
				runtime_condition = function() return vim.g.enable_golines end,
				extra_args = { "-t", "2", "-m", "80" },
			}),
			none_ls.builtins.formatting.isort, -- Sort Python imports
			none_ls.builtins.formatting.ktlint, -- Formatter for Kotlin
			none_ls.builtins.formatting.markdownlint,
			none_ls.builtins.formatting.nginx_beautifier,
			none_ls.builtins.formatting.npm_groovy_lint, -- Formatter for Groovy/Gradle
			none_ls.builtins.formatting.prettierd.with({
				env = {
					PRETTIERD_DEFAULT_CONFIG = vim.fs.joinpath(
						vim.fn.stdpath("config"),
						"config_files",
						"prettier.config.js"
					),
				},
			}),
			none_ls.builtins.formatting.prisma_format,
			none_ls.builtins.formatting.shfmt.with({ extra_filetypes = { "zsh" } }), -- Formatter for Bash
			none_ls.builtins.formatting.sqlfluff.with({
				extra_args = { "--dialect", "postgres" },
			}),
			none_ls.builtins.formatting.stylua.with({
				extra_args = function()
					local has_project_config = utils.root_has_file({
						".stylua.toml",
						"stylua.toml",
						".editorconfig",
					})
					if has_project_config then return nil end
					return {
						"--config-path",
						vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".stylua.toml"),
					}
				end,
			}),
		})

		return opts
	end,
}
