---@type LazySpec
return {
	"AstroNvim/astrolsp",
	dependencies = { "davidosomething/format-ts-errors.nvim" },
	---@type AstroLSPOpts
	opts = {
		native_lsp_config = true,
		features = {
			codelens = true,
			inlay_hints = true,
			semantic_tokens = true,
			signature_help = false,
		},
		defaults = {
			hover = {
				border = require("utils.constants").border_type,
				max_width = 100,
			},
			signature_help = { border = require("utils.constants").border_type },
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
		capabilities = {
			workspace = {
				didChangeConfiguration = { dynamicRegistration = true },
				didChangeWorkspaceFolders = { dynamicRegistration = true },
				diagnostics = { refreshSupport = true },
			},
		},
		---@diagnostic disable: missing-fields
		config = {
			lua_ls = { settings = { Lua = { hint = { enable = true } } } },
			emmet_language_server = {
				init_options = {
					preferences = { ["bem.enabled"] = true },
					--- @type boolean Defaults to `true`
					showAbbreviationSuggestions = true,
					showSuggestionsAsSnippets = false,
					syntaxProfiles = {
						html = { self_closing_style = "xhtml" },
					},
				},
			},
			gopls = {
				settings = {
					gopls = {
						analyses = { ST1000 = false },
						usePlaceholders = false,
					},
				},
			},
			tsgo = {
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
					-- NOTE: this is not working with tsgo yet
					-- experimental = {
					-- 	enableProjectDiagnostics = true,
					-- 	maxInlayHintLength = 30,
					-- },
				},
				handlers = {
					["textDocument/inlayHint"] = function(error, result, ctx)
						require("nikero.lsp.inlay_hints"):truncate(result)
						vim.lsp.inlay_hint.on_inlayhint(error, result, ctx)
					end,
					-- NOTE: `textDocument/publishDiagnostics` is not supported by tsgo
					["textDocument/diagnostic"] = function(error, result, ctx)
						local diagnostics = require("nikero.lsp.tsgo"):format_errors(result.items)
						if diagnostics ~= nil then result.diagnostics = diagnostics end
						vim.lsp.diagnostic.on_diagnostic(error, result, ctx)
					end,
				},
				on_attach = function(client, bufnr)
					-- NOTE: will be natively supported in v0.12
					-- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
					require("twoslash-queries").attach(client, bufnr)
				end,
			},
		},
		handlers = {
			vtsls = false,
			tsgo = function(server, opts)
				require("nikero.lsp.tsgo"):setup(opts)
				vim.lsp.enable(server)
			end,
			graphql = false,
		},
		servers = { "tsgo" },
		autocmds = { eslint_fix_on_save = false },
		mappings = {
			n = {
				["<Leader>uY"] = false, -- toggle LSP semantic highlighting
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
				["<leader>uY"] = false, -- toggle LSP semantic highlighting
			},
		},
	},
}
