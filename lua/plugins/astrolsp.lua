---@type LazySpec
return {
	"AstroNvim/astrolsp",
	dependencies = { "davidosomething/format-ts-errors.nvim" },
	---@type AstroLSPOpts
	opts = {
		features = {
			codelens = true,
			inlay_hints = true,
			semantic_tokens = true,
			signature_help = false,
		},
		formatting = {
			format_on_save = { enabled = false },
			timeout_ms = 2000,
			filter = function(client)
				local formatters_per_filetype = {
					sh = "bashls",
					zsh = "bashls",
					toml = "taplo",
					go = { "gopls", "null-ls" },
					cs = "csharp_ls",
					json = "null-ls",
					jsonc = "null-ls",
				}

				for _, filetype in pairs(require("utils.constants").filetype.javascript) do
					formatters_per_filetype[filetype] = { "eslint", "null-ls" }
				end

				local formatter = formatters_per_filetype[vim.bo.filetype]
				if formatter then
					if type(formatter) == "string" then return client.name == formatter end
					for _, client_name in ipairs(formatter) do
						if client.name == client_name then return true end
					end
					return false
				end
				return true
			end,
		},
		---@diagnostic disable: missing-fields
		config = {
			lua_ls = { settings = { Lua = { hint = { enable = true } } } },
			emmet_ls = {
				init_options = {
					jsx = {
						options = {
							["jsx.enabled"] = true,
							["output.selfClosingStyle"] = "xhtml",
							["bem.enabled"] = true,
						},
					},
				},
			},
			gopls = {
				settings = {
					gopls = {
						analyses = { ST1000 = false },
					},
				},
			},
			vtsls = {
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = false },
						},
						experimental = {
							useTsgo = true,
						},
					},
					javascript = {
						inlayHints = {
							parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = false },
						},
					},
					vtsls = {
						autoUseWorkspaceTsdk = true,
						experimental = {
							enableProjectDiagnostics = true,
							maxInlayHintLength = 30,
						},
					},
				},
				handlers = {
					---@diagnostic disable-next-line: redundant-parameter
					["textDocument/publishDiagnostics"] = function(_, result, ctx)
						if result.diagnostics == nil then return end

						-- ignore some tsserver diagnostics
						local idx = 1
						while idx <= #result.diagnostics do
							local entry = result.diagnostics[idx]

							local formatter = require("format-ts-errors")[entry.code]
							entry.message = formatter and formatter(entry.message) or entry.message

							-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
							if entry.code == 80001 then
								-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
								table.remove(result.diagnostics, idx)
							else
								idx = idx + 1
							end
						end

						vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
					end,
				},
				on_attach = function(client, bufnr)
					require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					require("twoslash-queries").attach(client, bufnr)
				end,
			},
		},
		autocmds = { eslint_fix_on_save = false },
		mappings = {
			n = {
				["<Leader>uY"] = false, -- toggle LSP symantic highlighting
				["<Leader>lG"] = false, -- search workspace symbols
				["<Leader>lR"] = false, -- search references
				["<Leader>uf"] = false, -- toggle buffer autoformatting
				["<Leader>uF"] = false, -- toggle global autoformatting
				["<Leader>uh"] = false, -- toggle buffer inlay hints
				["<Leader>uH"] = false, -- toggle global inlay hints
				["<Leader>u?"] = false, -- toggle automatic signature help
				-- TODO: not working
				["gra"] = false, -- gr code actions
				-- TODO: not working
				["grn"] = false, -- gr rename
				-- TODO: not working
				["gri"] = false, -- gr locations
				-- TODO: not working
				["grr"] = false, -- gr search references
			},
			v = {
				["<leader>uY"] = false, -- toggle LSP symantic highlighting
			},
		},
	},
}
