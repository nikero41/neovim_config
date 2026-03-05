---@type LazySpec
return {
	{
		"mfussenegger/nvim-lint",
		event = { "User NikeroFile" },
		lazy = false,
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
				makefile = { "checkmake" }, -- TODO:
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
					if vim.bo.modifiable then lint.try_lint("eslint_d") end
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		---@module "conform"
		---@param opts conform.setupOpts
		---@return conform.setupOpts
		opts = function(_, opts)
			opts = opts or {}

			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
				bash = { "shfmt", "shellcheck" },
				sh = { "shfmt", "shellcheck" },
				zsh = { "shfmt", "shellcheck" },
				cs = { "csharpier" },
				go = { "goimports", lsp_format = "last" },
				lua = { "stylua" },
				markdown = { "prettierd", "prettier", "markdownlint", stop_after_first = true },
				nginx = { "nginxfmt" },
				python = { "isort", "black" },
				sql = { "sqlfluff" },
			})

			opts.default_format_opts = { lsp_format = "fallback" }
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
				opts.formatters_by_ft[filetype] = { "prettierd" }
			end

			for _, language in ipairs(require("filetypes").javascript) do
				opts.formatters_by_ft[language] = { "prettierd", "prettier", stop_after_first = true }
			end

			opts.formatters = opts.formatters or {}
			opts.formatters.sqlfluff = opts.formatters.sqlfluff or {}
			opts.formatters.sqlfluff.require_cwd = false

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
