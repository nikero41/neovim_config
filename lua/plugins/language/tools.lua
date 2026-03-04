---@type LazySpec
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		---@module "conform"
		---@param opts conform.setupOpts
		---@return conform.setupOpts
		opts = function(_, opts)
			opts = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
				bash = { "shfmt" },
				c = {},
				kotlin = { "ktlint" },
				lua = { "stylua" },
				markdown = { "prettierd", "prettier", "markdownlint", stop_after_first = true },
				prisma = { "prisma-fmt" },
				python = { "isort", "black" },
				rust = { "rustfmt" },
				sql = { "sqlfmt" },
			})

			opts.default_format_opts = { lsp_format = "fallback" }

			for _, language in ipairs(require("filetypes").javascript) do
				opts.formatters_by_ft[language] = { "prettierd", "prettier", stop_after_first = true }
			end

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
