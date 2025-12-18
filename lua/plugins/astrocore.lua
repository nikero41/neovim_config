---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		features = {
			large_buf = { size = 1024 * 256, lines = 10000 },
			autopairs = true,
			cmp = true,
			diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
			highlighturl = true,
			notifications = true,
		},
		diagnostics = {
			virtual_text = true,
			underline = true,
			severity_sort = true,
			signs = true,
		},
		signs = {
			DiagnosticSignError = { text = "", texthl = "DiagnosticSignError" },
			DiagnosticSignWarn = { text = "", texthl = "DiagnosticSignWarn" },
			DiagnosticSignHint = { text = "󰌵", texthl = "DiagnosticSignHint" },
			DiagnosticSignInfo = { text = "", texthl = "DiagnosticSignInfo" },
		},
		options = {
			opt = {
				clipboard = "",
				scrolloff = 5,
				swapfile = false,
			},
			g = {
				loaded_perl_provider = 0,
				enable_golines = true,
			},
		},
		commands = {
			CommandPalette = {
				function()
					local commands = {
						{
							name = "LSP",
							commands = {
								{ "Restart tsserver", ":VtsExec restart_tsserver" },
								{ "Restart eslint_d", ":! eslint_d restart" },
								{ "Restart prettierd", ":!prettierd restart" },
								{ "Restart lua-ls", ":LspRestart lua-ls" },
							},
						},
						{
							name = "File",
							commands = {
								{ "Inspect types", ":InspectTwoslashQueries" },
								{ "Toggle inline folds", ":InlineFoldToggle" },
								{ "Search and Replace", ":SearchAndReplace" },
								{ "View on GitHub", function() Snacks.gitbrowse() end },
								{ "Toggle env variables", "CloakToggle" },
							},
						},
						{
							name = "Vim",
							commands = {
								{ "Open Lazy", function() require("lazy").home() end },
								{ "Open Mason", ":Mason" },
								{ "Zen mode", function() Snacks.zen() end },
								{ "Check health", ":checkhealth" },
								{
									"Change colorshceme",
									function() Snacks.picker.colorschemes() end,
								},
								{ "Commands", function() Snacks.picker.commands() end },
							},
						},
					}

					vim.ui.select(
						commands,
						{ prompt = "Select category:", format_item = function(item) return item.name end },
						function(category)
							if not category then return end
							vim.ui.select(
								category.commands,
								{ prompt = "Select command:", format_item = function(item) return item[1] end },

								function(command)
									if command and type(command[2]) == "function" then
										command[2]()
									elseif command and type(command[2]) == "string" then
										vim.cmd(command[2])
									end
								end
							)
						end
					)
				end,
				desc = "Command palette",
			},
		},
		mappings = require("keymaps"):create(),
		filetypes = {
			extension = {
				env = "dotenv",
				podspec = "ruby",
			},
			filename = {
				[".env"] = "dotenv",
				["tsconfig.json"] = "jsonc",
				[".eslintrc.json"] = "jsonc",
				[".yamlfmt"] = "yaml",
				[".sqlfluff"] = "toml",
				["Podfile"] = "ruby",
				["dot-zshrc"] = "zsh",
			},
			pattern = {
				["%.env%.[%w_.-]+"] = "dotenv",
			},
		},
	},
}
