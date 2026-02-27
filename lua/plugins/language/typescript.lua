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
		-- TODO:
		enabled = false,
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		keys = {
			{
				"<leader>ut",
				function()
					vim.notify(require("tailwind-tools.state").conceal.enabled and "classes unfolded" or "classes folded", nil, {
						title = "tailwind-tools",
					})
					require("tailwind-tools.conceal").toggle()
				end,
				desc = "Toggle tailwind classes",
			},
		},
		---@module "tailwind-tools"
		---@type fun(plugin: any, opts: TailwindTools.Option): TailwindTools.Option
		opts = function()
			local patterns = {}
			for _, language in pairs(require("filetypes").javascript) do
				patterns[language] = {
					"clsx%(([^)]+)%)",
					"cn%(([^)]+)%)",
				}
			end

			return {
				keymaps = { smart_increment = { enabled = true } },
				extension = { patterns = patterns },
			}
		end,
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = require("filetypes").javascript,
		opts = { keymaps = { toggle = "gL" } },
		config = function(_, opts)
			require("better-ts-errors").setup(opts)
			vim.lsp.config("tsgo", {
				handlers = {
					["textDocument/diagnostic"] = function(error, result, ctx)
						local idx = 1
						while idx <= #result.diagnostics do
							local entry = result.diagnostics[idx]

							local formatter = require("format-ts-errors")[entry.code]
							entry.message = formatter and formatter(entry.message) or entry.message

							local ignore_codes = {
								[80001] = "File is a CommonJS module; it may be converted to an ES module.",
							}

							-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
							if ignore_codes[entry.code] then
								table.remove(result.diagnostics, idx)
							else
								idx = idx + 1
							end
						end

						local diagnostics = require("nikero.lsp.tsgo"):format_errors(result.items)
						if diagnostics ~= nil then result.diagnostics = diagnostics end
						vim.lsp.diagnostic.on_diagnostic(error, result, ctx)
					end,
				},
			})
		end,
	},
}
