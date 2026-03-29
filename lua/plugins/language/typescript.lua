---@type LazySpec
return {
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "BufRead package.json",
		opts = { hide_up_to_date = true },
	},
	{
		"dmmulroy/tsc.nvim",
		cmd = "TSC",
		---@module "tsc"
		---@type Opts
		opts = { use_trouble_qflist = true },
	},
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
		cmd = {
			"TwoSlashQueriesEnable",
			"TwoSlashQueriesDisable",
			"TwoSlashQueriesInspect",
			"TwoSlashQueriesRemove",
		},
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
		opts = {
			keymaps = {
				toggle = "gL",
				go_to_definition = "<leader>dx",
			},
		},
	},
	{
		"davidosomething/format-ts-errors.nvim",
		ft = require("filetypes").javascript,
		config = function()
			local ignore_codes = {
				[80001] = "File is a CommonJS module; it may be converted to an ES module.",
			}

			vim.lsp.config("tsgo", {
				handlers = {
					["textDocument/diagnostic"] = function(error, result, ctx)
						if not result or result.kind ~= "full" then
							return vim.lsp.diagnostic.on_diagnostic(error, result, ctx)
						end

						local idx = 1
						while idx <= #result.items do
							local entry = result.items[idx]

							local formatter = require("format-ts-errors")[entry.code]
							entry.message = formatter and formatter(entry.message) or entry.message

							-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
							if ignore_codes[entry.code] then
								table.remove(result.items, idx)
							else
								idx = idx + 1
							end
						end

						return vim.lsp.diagnostic.on_diagnostic(error, result, ctx)
					end,
				},
			})
		end,
	},
	{
		"razak17/tailwind-fold.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = vim.list_extend(
			vim.deepcopy(require("filetypes").javascript),
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
