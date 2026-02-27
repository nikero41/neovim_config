---@type LazySpec
return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason-org/mason.nvim" },
		cmd = { "ConformInfo" },
		keys = {
			{ "<leader>lf", function() require("conform").format({ async = true }) end, desc = "Format file" },
		},
		---@module "conform"
		---@param opts conform.setupOpts
		---@return conform.setupOpts
		opts = function(_, opts)
			local new_opts = vim.tbl_extend("force", opts, {
				formatters_by_ft = {
					bash = { "shfmt" },
					c = {},
					kotlin = { "ktlint" },
					lua = { "stylua" },
					markdown = { "prettierd", "prettier", "markdownlint", stop_after_first = true },
					prisma = { "prisma-fmt" },
					python = { "isort", "black" },
					rust = { "rustfmt" },
					sql = { "sqlfmt" },
				},
				default_format_opts = { lsp_format = "fallback" },
			})

			for _, language in ipairs(require("filetypes").javascript) do
				new_opts.formatters_by_ft[language] = { "prettierd", "prettier", stop_after_first = true }
			end

			return new_opts
		end,
		init = function()
			vim.api.nvim_create_user_command(
				"Format",
				function() require("conform").format({ async = true }) end,
				{ desc = "Format" }
			)
		end,
	},
}
