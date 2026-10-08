local tools = require("nikero.tools")

---@param config_name ToolConfigName
---@param opts? { arg?: string, bufnr?: integer }
---@return string[]
local function default_config_args(config_name, opts)
	opts = opts or {}

	local config = tools.configs[config_name]
	local has_project_config = tools:find_config_file(config, { bufnr = opts.bufnr })
	if has_project_config or not config.default_config_path then return {} end
	return { opts.arg or "--config", config.default_config_path }
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
				css = { "stylelint" },
				less = { "stylelint" },
				postcss = { "stylelint" },
				scss = { "stylelint" },
				go = { "golangcilint" },
				groovy = { "npm-groovy-lint" },
				lua = { "selene" },
				markdown = { "markdownlint-cli2" },
				make = { "checkmake" },
				python = { "mypy" },
				sql = { "sqlfluff" },
				yaml = { "yamllint" },
			}

			for _, language in ipairs(require("filetypes").javascript) do
				lint.linters_by_ft[language] = { "eslint_d" }
			end

			lint.linters["eslint_d"].env = { ESLINT_D_PPID = vim.fn.getpid() }

			---@param config_name ToolConfigName
			---@return (fun():string)[]
			local function linter_args_mapper(config_name)
				return {
					function()
						local config_args = default_config_args(config_name)
						return #config_args > 0 and config_args[1] or ""
					end,
					function()
						local config_args = default_config_args(config_name)
						return #config_args > 0 and config_args[2] or ""
					end,
				}
			end

			vim.list_extend(lint.linters.selene.args, linter_args_mapper("selene"))
			vim.list_extend(lint.linters.stylelint.args, linter_args_mapper("stylelint"))
			vim.list_extend(lint.linters.sqlfluff.args, linter_args_mapper("sqlfluff"))
			vim.list_extend(lint.linters.sqlfluff.args, {
				function()
					local config_args = default_config_args("sqlfluff")
					return #config_args > 0 and "--dialect" or ""
				end,
				function()
					local config_args = default_config_args("sqlfluff")
					return #config_args > 0 and require("nikero.database").dialect or ""
				end,
			})
			vim.list_extend(lint.linters["markdownlint-cli2"].args, linter_args_mapper("markdownlint"))

			lint.linters.yamllint.env =
				{ YAMLLINT_CONFIG_FILE = tools.configs.yamllint.default_config_path }

			lint.linters.dotenv_linter.env =
				{ DOTENV_LINTER_IGNORE_CHECKS = table.concat({ "QuoteCharacter", "UnorderedKey" }, ",") }

			local Timer = require("nikero.timer")
			---@type table<integer, Timer>
			local timers = {}
			local group = vim.api.nvim_create_augroup("lint", { clear = true })

			local function lint_buffer(bufnr)
				if not vim.api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].modifiable then return end

				vim.api.nvim_buf_call(bufnr, function()
					local ok, msg = pcall(lint.try_lint, nil, {
						filter = function(linter)
							return linter.name ~= "eslint_d"
								or vim.tbl_contains(tools:get_js_tools(bufnr).linter, "eslint")
						end,
					})
					if not ok then
						vim.notify(msg or "Error while linting", vim.log.levels.ERROR, { title = "Lint" })
					end
				end)
			end

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = group,
				callback = function(args)
					local timer = timers[args.buf]
					if timer then timer:stop() end
					lint_buffer(args.buf)
				end,
			})

			vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
				group = group,
				callback = function(args)
					vim.schedule(function() lint_buffer(args.buf) end)
				end,
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				group = group,
				callback = function(args)
					local timer = timers[args.buf]
					if not timer then
						timer = Timer.new(function() lint_buffer(args.buf) end)
						timers[args.buf] = timer
					end
					timer:start(300)
				end,
			})

			vim.api.nvim_create_autocmd("BufWipeout", {
				group = group,
				callback = function(args)
					local timer = timers[args.buf]
					if not timer then return end
					timer:close()
					timers[args.buf] = nil
				end,
			})

			-- User File is emitted during BufReadPost/BufNewFile, before this plugin loads.
			vim.schedule(function() lint_buffer(vim.api.nvim_get_current_buf()) end)
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

			---@param linters string[]
			local function with_js_formatters(linters)
				return vim.list_extend(linters, {
					"eslint_d",
					"prettierd",
					-- "oxlint",
					lsp_format = "first",
				})
			end

			opts.formatters_by_ft = vim.tbl_extend(
				"force",
				opts.formatters_by_ft or {},
				{
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
					markdown = with_js_formatters({ "markdownlint" }),
					nginx = { "nginxfmt" },
					python = { "isort", "black" },
					rust = { "dioxus", lsp_format = "first" },
					sql = { "sqlfluff", lsp_format = "never" },
					templ = { "templ" },
					json = with_js_formatters({}),
					jsonc = with_js_formatters({}),
					css = with_js_formatters({}),
					scss = with_js_formatters({}),
					html = with_js_formatters({}),
					graphql = with_js_formatters({}),
					yaml = with_js_formatters({}),
				},
				vim
					.iter(vim.deepcopy(require("filetypes").javascript))
					:map(function() return with_js_formatters({}) end)
			)

			opts.formatters = {
				sqlfluff = {
					append_args = function(_, ctx)
						return default_config_args("sqlfluff", { bufnr = ctx.buf })
					end,
				},
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
					append_args = function(_, ctx)
						return default_config_args("stylua", { arg = "--config-path", bufnr = ctx.buf })
					end,
				},
				golines = {
					condition = function() return vim.g.enable_golines end,
					append_args = { "-t", "2", "-m", "80" },
				},
				dioxus = {
					command = "dx",
					args = { "fmt", "--file", "$FILENAME" },
					stdin = false,
					condition = function(_, ctx)
						return tools:find_config_file({ "dioxus.toml" }, { bufnr = ctx.buf }) ~= nil
					end,
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
					filter = function(client) return client.name ~= "tsc" and client.name ~= "ts_ls" end,
				}

				require("conform").format(vim.tbl_extend("force", format_opts, { async = true }))
			end, { range = true, desc = "Format" })
		end,
	},
}
