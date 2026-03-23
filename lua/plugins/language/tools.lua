---@type LazySpec
return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
		event = "User File",
		opts = function(_, opts)
			local none_ls = require("null-ls")

			opts.sources = {
				require("none-ls.code_actions.eslint_d"),
				none_ls.builtins.code_actions.gitsigns,
				none_ls.builtins.code_actions.refactoring.with({
					extra_filetypes = require("filetypes").javascript,
				}),
				none_ls.builtins.code_actions.gomodifytags,
				none_ls.builtins.code_actions.impl,
			}

			return opts
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = "User File",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				bash = { "shellcheck" },
				sh = { "shellcheck" },
				zsh = { "shellcheck", "zsh" },
				dockerfile = { "hadolint" },
				dotenv = { "dotenv_linter" },
				json = { "jsonlint" },
				go = { "golangcilint" },
				groovy = { "npm-groovy-lint" },
				lua = { "selene" },
				markdown = { "markdownlint" },
				make = { "checkmake" },
				python = { "mypy", "basedpyright" },
				sql = { "sqlfluff" },
				yaml = { "yamllint" },
			}

			for _, language in ipairs(require("filetypes").javascript) do
				lint.linters_by_ft[language] = { "eslint_d" }
			end

			lint.linters["eslint_d"].env = { ESLINT_D_PPID = vim.fn.getpid() }

			table.insert(lint.linters.selene.args, function()
				local project_configs = { ".selene.toml", "selene.toml" }
				local has_project_config = vim.iter(project_configs):any(
					function(filename) return vim.uv.fs_stat(filename) ~= nil end
				)
				if has_project_config then return "" end
				return "--config="
					.. vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".selene.toml")
			end)

			table.insert(lint.linters.stylelint.args, function()
				local project_configs = {
					".stylelintrc.js",
					"stylelint.config.js",
					".stylelintrc.mjs",
					"stylelint.config.mjs",
					".stylelintrc.cjs",
					"stylelint.config.cjs",
					".stylelintrc.json",
					".stylelintrc.yml",
					".stylelintrc.yaml",
				} or require("nikero.utils"):check_json_key_exists(
					vim.fs.joinpath(vim.uv.cwd(), "package.json"),
					"stylelint"
				)
				local has_project_config = vim.iter(project_configs):any(
					function(filename) return vim.uv.fs_stat(filename) ~= nil end
				)
				if has_project_config then return "" end
				return "--config="
					.. vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", "stylelint.config.js")
			end)

			table.insert(lint.linters.sqlfluff.args, function()
				local args = "--dialect=postgres"
				local project_configs =
					{ "setup.cfg", "tox.ini", "pep8.ini", ".sqlfluff", "pyproject.toml" }
				local has_project_config = vim.iter(project_configs):any(
					function(filename) return vim.uv.fs_stat(filename) ~= nil end
				)
				if has_project_config then return args end
				return args
					.. " --config="
					.. vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".sqlfluff")
			end)

			lint.linters.yamllint.env = {
				YAMLLINT_CONFIG_FILE = vim.fs.joinpath(
					vim.fn.stdpath("config"),
					"config_files",
					".yamllint.yaml"
				),
			}

			lint.linters.dotenv_linter.env = {
				DOTENV_LINTER_IGNORE_CHECKS = table.concat({ "QuoteCharacter", "UnorderedKey" }, ","),
			}

			vim.api.nvim_create_autocmd(
				{ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged", "BufEnter" },
				{
					group = vim.api.nvim_create_augroup("lint", { clear = true }),
					callback = function()
						if vim.bo.modifiable then
							local ok, msg = pcall(lint.try_lint)
							if not ok then
								vim.notify(msg or "Error while linting", vim.log.levels.ERROR, { title = "Lint" })
							end
						end
					end,
				}
			)
		end,
	},
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		event = "BufWritePre",
		keys = {
			{
				"<Leader>ltl",
				function()
					vim.g.enable_golines = not vim.g.enable_golines
					vim.notify(
						"goliens " .. (vim.g.enable_golines and "enabled" or "disabled"),
						vim.log.levels.INFO,
						{ title = "LSP toggle" }
					)
				end,
				desc = "Toggle golines",
			},
		},
		---@module "conform"
		---@param opts conform.setupOpts
		---@return conform.setupOpts
		opts = function(_, opts)
			---@param buffer integer
			---@param ... string
			---@return string
			local function first(buffer, ...)
				local conform = require("conform")
				for i = 1, select("#", ...) do
					local formatter = select(i, ...)
					if conform.get_formatter_info(formatter, buffer).available then return formatter end
				end
				return select(1, ...)
			end

			opts = opts or {}

			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
				bash = { "shfmt", "shellcheck" },
				sh = { "shfmt", "shellcheck" },
				zsh = { "shfmt", "shellcheck" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cs = { "csharpier" },
				go = { "goimports", lsp_format = "last" },
				groovy = { "npm-groovy-lint" },
				lua = { "stylua" },
				markdown = function(buffer)
					return { "markdownlint", first(buffer, "prettierd", "prettier") }
				end,
				nginx = { "nginxfmt" },
				python = { "isort", "black" },
				sql = { "sqlfluff" },
			})

			for _, filetype in ipairs({
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"css",
				"scss",
				"less",
				"html",
				"json",
				"jsonc",
				"yaml",
				"markdown",
				"markdown.mdx",
				"graphql",
				"handlebars",
				"svelte",
				"astro",
				"htmlangular",
			}) do
				opts.formatters_by_ft[filetype] = function(buffer)
					return { first(buffer, "prettierd", "prettier") }
				end
			end

			for _, language in ipairs(require("filetypes").javascript) do
				opts.formatters_by_ft[language] = function(buffer)
					return { "eslint_d", first(buffer, "prettierd", "prettier") }
				end
			end

			opts.formatters = {
				sqlfluff = { append_args = { "--dialect", "postgres" } },
				prettierd = {
					env = {
						PRETTIERD_DEFAULT_CONFIG = vim.fs.joinpath(
							vim.fn.stdpath("config"),
							"config_files",
							"prettier.config.js"
						),
					},
				},
				stylua = {
					append_args = function()
						local project_configs = { ".stylua.toml", "stylua.toml", ".editorconfig" }
						local has_project_config = vim.iter(project_configs):any(
							function(filename) return vim.uv.fs_stat(filename) ~= nil end
						)
						if has_project_config then return {} end
						return {
							"--config-path",
							vim.fs.joinpath(vim.fn.stdpath("config"), "config_files", ".stylua.toml"),
						}
					end,
				},
				golines = {
					condition = function() return vim.g.enable_golines end,
					append_args = { "-t", "2", "-m", "80" },
				},
			}

			opts.default_format_opts = { lsp_format = "fallback" }

			return opts
		end,
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end

				if vim.bo.modified then
					vim.api.nvim_create_autocmd("BufWritePost", {
						group = vim.api.nvim_create_augroup("conform", { clear = true }),
						callback = function()
							require("conform").format({ async = true, lsp_format = "fallback", range = range })
						end,
						once = true,
					})
				else
					require("conform").format({ async = true, lsp_format = "fallback", range = range })
				end
			end, { range = true, desc = "Format" })
		end,
	},
}
