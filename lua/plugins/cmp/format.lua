---@type LazySpec
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{ "<leader>lf", function() require("conform").format({ async = true }) end, desc = "Format file" },
		},
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				bash = { "shfmt" },
				c = {},
				javascript = { "prettierd", "prettier", stop_after_first = true },
				kotlin = { "ktlint" },
				lua = { "stylua" },
				markdown = { "prettierd", "prettier", "markdownlint", stop_after_first = true },
				prisma = { "prisma-fmt" },
				python = { "isort", "black" },
				rust = { "rustfmt" },
				sql = { "sqlfmt" },
			},
			default_format_opts = { lsp_format = "fallback" },
		},
	},
}
