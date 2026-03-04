return {
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		name = "window-picker",
		opts = {
			hint = "floating-big-letter",
			picker_config = { handle_mouse_click = true },
			show_prompt = false,
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		cmd = { "Neotree" },
		keys = {
			{
				"<Leader>o",
				function()
					if vim.bo.filetype == "neo-tree" then
						vim.cmd.wincmd("p")
					else
						vim.cmd.Neotree("focus")
					end
				end,
				desc = "Toggle Explorer Focus",
			},
			{
				"<leader>ue",
				function() vim.cmd.Neotree({ "toggle", "action=show" }) end,
				desc = "Toggle Explorer",
			},
		},
		---@module 'neo-tree'
		---@type neotree.Config
		opts = {
			sources = { "filesystem" },
			add_blank_line_at_top = false,
			close_if_last_window = true,
			enable_cursor_hijack = true,
			popup_border_style = "",
			use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
			use_default_mappings = true,

			---@diagnostic disable-next-line: missing-fields
			source_selector = {
				winbar = false, -- toggle to show selector on winbar
				statusline = false, -- toggle to show selector on statusline
			},

			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function() vim.cmd("highlight! Cursor blend=100") end,
				},
				{
					event = "neo_tree_buffer_leave",
					handler = function() vim.cmd("highlight! Cursor guibg=#5f87af blend=0") end,
				},
				{
					event = "neo_tree_window_after_open",
					handler = function()
						vim.cmd.wincmd("=")
						Snacks.dashboard.update()
					end,
				},
				{
					event = "neo_tree_window_after_close",
					handler = function()
						vim.cmd("wincmd =")
						Snacks.dashboard.update()
					end,
				},
			},
			default_component_configs = {
				--diagnostics = {
				--  symbols = {
				--    hint = "H",
				--    info = "I",
				--    warn = "!",
				--    error = "X",
				--  },
				--  highlights = {
				--    hint = "DiagnosticSignHint",
				--    info = "DiagnosticSignInfo",
				--    warn = "DiagnosticSignWarn",
				--    error = "DiagnosticSignError",
				--  },
				--},
				indent = {
					padding = 0,
					with_markers = true,
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰉖",
					folder_empty_open = "󰷏",
					use_filtered_colors = true,
					default = "*",
					provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
						local text, hl
						local mini_icons = require("mini.icons")
						if node.type == "file" then
							text, hl = mini_icons.get("file", node.name)
						elseif node.type == "directory" then
							text, hl = mini_icons.get("directory", node.name)
							if node:is_expanded() then text = nil end
						end

						if text then icon.text = text end
						if hl then icon.highlight = hl end
					end,
				},
				kind_icon = {
					provider = function(icon, node)
						icon.text, icon.highlight = require("mini.icons").get("lsp", node.extra.kind.name)
					end,
				},
				modified = {
					symbol = "[+] ",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
					-- Take values in { false (no highlight), true (only loaded),
					-- "all" (both loaded and unloaded)}. For more information,
					-- see the `show_unloaded` config of the `buffers` source.
					use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "✚", -- NOTE: you can set any of these to an empty string to not show them
						deleted = "✖",
						modified = "",
						renamed = "󰁕",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
					align = "right",
				},
				},
			},
			-- Global custom commands that will be available in all sources (if not overridden in `opts[source_name].commands`)
			--
			-- You can then reference the custom command by adding a mapping to it:
			--    globally    -> `opts.window.mappings`
			--    locally     -> `opt[source_name].window.mappings` to make it source specific.
			--
			-- commands = {              |  window {                 |  filesystem {
			--   hello = function()      |    mappings = {           |    commands = {
			--     print("Hello world")  |      ["<C-c>"] = "hello"  |      hello = function()
			--   end                     |    }                      |        print("Hello world in filesystem")
			-- }                         |  }                        |      end
			--
			-- see `:h neo-tree-custom-commands-global`
			commands = {}, -- A list of functions

			window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
				insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
				-- "child":   Insert nodes as children of the directory under cursor.
				-- "sibling": Insert nodes  as siblings of the directory under cursor.
				-- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
				-- You can also create your own commands by providing a function instead of a string.
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					-- ["<cr>"] = { "open", config = { expand_nested_files = true } }, -- expand nested file takes precedence
					["<esc>"] = "cancel", -- close preview or floating neo-tree window
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
							use_snacks_image = true,
							use_image_nvim = true,
							-- title = "Neo-tree Preview", -- You can define a custom title for the preview floating window.
						},
					},
					["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
					["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					-- ["S"] = "split_with_window_picker",
					["s"] = "open_vsplit",
					-- ["sr"] = "open_rightbelow_vs",
					-- ["sl"] = "open_leftabove_vs",
					-- ["s"] = "vsplit_with_window_picker",
					["t"] = "open_tabnew",
					-- ["<cr>"] = "open_drop",
					-- ["t"] = "open_tab_drop",
					["w"] = "open_with_window_picker",
					["C"] = "close_node",
					--["C"] = "close_all_subnodes",
					["z"] = "close_all_nodes",
					--["Z"] = "expand_all_nodes",
					--["Z"] = "expand_all_subnodes",
					["R"] = "refresh",
					["a"] = {
						"add",
						-- some commands may take optional config options, see `:h neo-tree-mappings` for details
						config = {
							show_path = "none", -- "none", "relative", "absolute"
						},
					},
					["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["<C-r>"] = "clear_clipboard",
					["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
					["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
					["e"] = "toggle_auto_expand_width",
					["q"] = "close_window",
					["?"] = "show_help",
					-- You can sort by command name with:
					-- ["?"] = { "show_help", config = { sorter = function(a, b) return a.mapping.text < b.mapping.text end } },
					-- The type of a and b are neotree.Help.Mapping
					["<"] = "prev_source",
					[">"] = "next_source",
				},
			},
			filesystem = {
				window = {
					mappings = {
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						--["/"] = {"fuzzy_finder", config = { keep_filter_on_submit = true }},
						--["/"] = "filter_as_you_type", -- this was the default until v1.28
						["D"] = "fuzzy_finder_directory",
						-- ["D"] = "fuzzy_sorter_directory",
						["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
						["f"] = "filter_on_submit",
						["<C-x>"] = "clear_filter",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["[g"] = "prev_git_modified",
						["]g"] = "next_git_modified",
						["i"] = "show_file_details", -- see `:h neo-tree-file-actions` for options to customize the window.
						["b"] = "rename_basename",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["og"] = { "order_by_git_status", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					},
					fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
						["<down>"] = "move_cursor_down",
						["<C-n>"] = "move_cursor_down",
						["<up>"] = "move_cursor_up",
						["<C-p>"] = "move_cursor_up",
						["<Esc>"] = "close",
						["<S-CR>"] = "close_keep_filter",
						["<C-CR>"] = "close_clear_filter",
						["<C-w>"] = { "<C-S-w>", raw = true },
						{
							-- normal mode mappings
							n = {
								["j"] = "move_cursor_down",
								["k"] = "move_cursor_up",
								["<S-CR>"] = "close_keep_filter",
								["<C-CR>"] = "close_clear_filter",
								["<esc>"] = "close",
							},
						},
						-- ["<esc>"] = "noop", -- if you want to use normal mode
						-- ["key"] = function(state, scroll_padding) ... end,
					},
				},
				cwd_target = {
					sidebar = "tab", -- sidebar is when position = left or right
					current = "window", -- current is when position = current
				},
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
					children_inherit_highlights = true, -- whether children of filtered parents should inherit their parent's highlight group
					show_hidden_count = true,
				},
				group_empty_dirs = false, -- when true, empty folders will be grouped together
				follow_current_file = {
					enabled = true,
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				desc = "Open Neo-Tree on startup with directory",
				callback = function(args)
					if package.loaded["neo-tree"] then return true end

					local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
					vim.notify(vim.inspect(stats), nil, { title = "🪚 stats", ft = "lua" })
					if stats and stats.type == "directory" then
						require("lazy").load({ plugins = { "neo-tree.nvim" } })
						pcall(vim.api.nvim_exec_autocmds, "BufEnter", { group = "NeoTree_NetrwDeferred", buffer = args.buf })
						return true
					end
				end,
			})
		end,
	},
}
