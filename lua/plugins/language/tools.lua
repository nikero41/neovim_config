local tools = require("nikero.tools")

---@param config_name ToolConfigName
---@param opts? { arg?: string, bufnr?: integer }
---@return string[]
local function default_config_args(config_name, opts)
	local opts = opts or {}

	local config = tools.configs[config_name]
	local has_project_config = tools:find_config_file(config, { bufnr = opts.bufnr })
	if has_project_config then return {} end
	return { opts.args or "--config", config.default_config_path }
end

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
				astro = { "eslint_d" },
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

			table.insert(lint.linters.selene.args, function() return default_config_args("selene") end)

			table.insert(
				lint.linters.stylelint.args,
				function() return default_config_args("stylelint") end
			)

			table.insert(
				lint.linters.sqlfluff.args,
				function() return default_config_args("sqlfluff") end
			)

			lint.linters.yamllint.env = { YAMLLINT_CONFIG_FILE = tools:get_default_config("yamllint") }

			lint.linters.dotenv_linter.env =
				{ DOTENV_LINTER_IGNORE_CHECKS = table.concat({ "QuoteCharacter", "UnorderedKey" }, ",") }

			vim.api.nvim_create_autocmd(
				{ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged", "BufEnter" },
				{
					group = vim.api.nvim_create_augroup("lint", { clear = true }),
					callback = function()
						if vim.bo.modifiable then
							local ok, msg = pcall(lint.try_lint, nil, {
								filter = function(linter)
									if linter.name == "eslint_d" then
										return vim.tbl_contains(tools:get_js_tools(0).linter, "eslint")
									end
									return true
								end,
							})
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
				"<leader>ltl",
				function()
					vim.g.enable_golines = not vim.g.enable_golines
					vim.notify(
						"golines " .. (vim.g.enable_golines and "enabled" or "disabled"),
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
			opts = opts or {}

			opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
				astro = { "eslint_d", "prettierd" },
				bash = { "shfmt", "shellcheck" },
				sh = { "shfmt", "shellcheck" },
				zsh = { "shfmt", "shellcheck" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cs = { "csharpier" },
				go = { "goimports", "golines", lsp_format = "last" },
				groovy = { "npm-groovy-lint" },
				lua = { "stylua" },
				markdown = { "markdownlint" },
				nginx = { "nginxfmt" },
				python = { "isort", "black" },
				sql = { "sqlfluff", lsp_format = "never" },
				templ = { "templ" },
			})

			for _, language in
				ipairs(vim.list_extend(vim.deepcopy(require("filetypes").javascript), {
					"json",
					"jsonc",
					"css",
					"scss",
					"html",
					"graphql",
					"markdown",
					"markdown.mdx",
					"yaml",
				}))
			do
				opts.formatters_by_ft[language] =
					{ "eslint_d", "prettierd", "oxlint", lsp_format = "first" }
			end

			opts.formatters = {
				sqlfluff = { append_args = default_config_args("sqlfluff") },
				oxlint = {
					condition = function(_, ctx)
						return vim.tbl_contains(tools:get_js_tools(ctx.buf).linter, "oxlint")
					end,
				},
				eslint_d = {
					condition = function(_, ctx)
						return vim.tbl_contains(tools:get_js_tools(ctx.buf).linter, "eslint")
					end,
				},
				prettierd = {
					condition = function(_, ctx)
						return vim.tbl_contains(tools:get_js_tools(ctx.buf).formatter, "prettier")
					end,
					env = { PRETTIERD_DEFAULT_CONFIG = tools.configs.prettier.default_config_path },
				},
				prettier = {
					condition = function(_, ctx)
						return vim.tbl_contains(tools:get_js_tools(ctx.buf).formatter, "prettier")
					end,
					env = { PRETTIERD_DEFAULT_CONFIG = tools.configs.prettier.default_config_path },
				},
				stylua = {
					append_args = default_config_args("stylua", { arg = "--config-path" }),
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
				local buffer = vim.api.nvim_get_current_buf()

				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end

				local format_opts = {
					bufnr = buffer,
					range = range,
					filter = function(client) return client.name ~= "tsgo" end,
				}

				if not vim.bo[buffer].modified then
					require("conform").format(vim.tbl_extend("force", format_opts, { async = true }))
					return
				end

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("conform-" .. buffer, { clear = true }),
					buffer = buffer,
					callback = function()
						require("conform").format(vim.tbl_extend("force", format_opts, { async = false }))
					end,
					once = true,
				})
			end, { range = true, desc = "Format" })
		end,
	},
}
