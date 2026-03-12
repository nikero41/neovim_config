---@type LazySpec
return {
	{
		"mfussenegger/nvim-lint",
		event = { "User File" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				bash = { "shellcheck" },
				sh = { "shellcheck" },
				zsh = { "shellcheck" },
				dockerfile = { "hadolint" },
				go = { "golangcilint" },
				groovy = { "npm-groovy-lint" },
				lua = { "selene" },
				markdown = { "markdownlint" },
				make = { "checkmake" },
				python = { "mypy" },
				sql = { "sqlfluff" },
				yaml = { "yamllint" },
			}

			vim.env.ESLINT_D_PPID = vim.fn.getpid()
			for _, language in ipairs(require("filetypes").javascript) do
				lint.linters_by_ft[language] = { "eslint_d" }
			end

			lint.try_lint()

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
				group = lint_augroup,
				callback = function()
					if vim.bo.modifiable then lint.try_lint() end
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
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
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true, desc = "Format" })
		end,
	},
}
