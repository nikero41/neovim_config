---@type LazySpec
return {
	{
		"axelvc/template-string.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = require("filetypes").javascript,
		opts = {
			jsx_brackets = true,
			remove_template_strings = true,
			restore_quotes = { normal = [["]], jsx = [["]] },
		},
	},
	{
		"marilari88/twoslash-queries.nvim",
		ft = require("filetypes").javascript,
		cmd = { "TwoSlashQueriesEnable", "TwoSlashQueriesDisable", "TwoSlashQueriesInspect", "TwoSlashQueriesRemove" },
		opts = { multi_line = true },
		config = function(_, opts)
			require("twoslash-queries").setup(opts)
			vim.lsp.config("tsgo", {
				on_attach = function(client, buffer) require("twoslash-queries").attach(client, buffer) end,
			})
		end,
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = require("filetypes").javascript,
		opts = { keymaps = { toggle = "gL" } },
	},
	{
		"davidosomething/format-ts-errors.nvim",
		ft = require("filetypes").javascript,
		config = function()
			vim.lsp.config("tsgo", {
				handlers = {
					["textDocument/diagnostic"] = function(error, result, ctx)
						local idx = 1
						while idx <= #result.items do
							local entry = result.items[idx]

							local formatter = require("format-ts-errors")[entry.code]
							entry.message = formatter and formatter(entry.message) or entry.message

							local ignore_codes = {
								[80001] = "File is a CommonJS module; it may be converted to an ES module.",
							}

							-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
							if ignore_codes[entry.code] then
								table.remove(result.items, idx)
							else
								idx = idx + 1
							end
						end

						vim.lsp.diagnostic.on_diagnostic(error, result, ctx)
					end,
				},
			})
		end,
	},
	{
		"razak17/tailwind-fold.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = vim.tbl_extend(
			"force",
			require("filetypes").javascript,
			{ "html", "svelte", "astro", "vue", "typescriptreact", "php", "blade" }
		),
		keys = {
			{ "<leader>ut", vim.cmd.TailwindFoldToggle, desc = "Toggle tailwind classes" },
		},
		opts = {
			enabled = false,
			symbol = "󱏿",
			highlight = { fg = "#38BDF8" },
		},
	},
}
