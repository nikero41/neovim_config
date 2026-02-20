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
		autocmds = {
			autotag_fix = {
				{
					event = "InsertCharPre",
					callback = function()
						if vim.v.char ~= "/" then return end

						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						local line = vim.api.nvim_get_current_line()
						local char = line:sub(col, col)

						if char == "<" then
							vim.schedule(function()
								-- move cursor to the beginning of the tag to simulate the behavior of the default behavior of the plugin
								vim.api.nvim_win_set_cursor(0, { row, col - 1 })
								require("nvim-ts-autotag.internal").close_slash_tag()
								-- add slash at the beginning of the tag
								vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "/" })
								local new_row, new_col = unpack(vim.api.nvim_win_get_cursor(0))
								local next_col = new_col + 1
								-- move cursor to the end of the tag and remove initial slash
								vim.api.nvim_win_set_cursor(0, { new_row, next_col })
								vim.api.nvim_buf_set_text(
									0,
									new_row - 1,
									next_col,
									new_row - 1,
									next_col + 1,
									{ "" }
								)
							end)
						end
					end,
				},
			},
		},
		diagnostics = {
			virtual_text = true,
			underline = true,
			severity_sort = true,
			signs = true,
			float = { border = require("utils.constants").border_type },
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
				winborder = require("utils.constants").border_type,
			},
			g = {
				loaded_perl_provider = 0,
				enable_golines = true,
				---@module "opencode"
				---@type opencode.Opts
				opencode_opts = {
					provider = {
						enabled = "tmux",
						tmux = {},
					},
				},
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
									"Change colorscheme",
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
				tmux = "tmux",
				gitconfig = "gitconfig",
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
