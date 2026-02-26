return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
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
						vim.cmd("wincmd =")
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
				container = {
					enable_character_fade = true,
					width = "100%",
					right_padding = 0,
				},
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
					use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
					-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
					-- then these will never be used.
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
				-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
				file_size = {
					enabled = true,
					width = 12, -- width of the column
					required_width = 64, -- min width of window required to show this column
				},
				type = {
					enabled = true,
					width = 10, -- width of the column
					required_width = 110, -- min width of window required to show this column
				},
				last_modified = {
					enabled = true,
					width = 20, -- width of the column
					required_width = 88, -- min width of window required to show this column
					format = "%Y-%m-%d %I:%M %p", -- format string for timestamp (see `:h os.date()`)
					-- or use a function that takes in the date in seconds and returns a string to display
					--format = require("neo-tree.utils").relative_date, -- enable relative timestamps
				},
				created = {
					enabled = false,
					width = 20, -- width of the column
					required_width = 120, -- min width of window required to show this column
					format = "%Y-%m-%d %I:%M %p", -- format string for timestamp (see `:h os.date()`)
					-- or use a function that takes in the date in seconds and returns a string to display
					--format = require("neo-tree.utils").relative_date, -- enable relative timestamps
				},
				symlink_target = {
					enabled = false,
					text_format = " ➛ %s", -- %s will be replaced with the symlink target's path.
				},
			},
			-- The renderer section provides the renderers that will be used to render the tree.
			--   The first level is the node type.
			--   For each node type, you can specify a list of components to render.
			--       Components are rendered in the order they are specified.
			--         The first field in each component is the name of the function to call.
			--         The rest of the fields are passed to the function as the "config" argument.
			renderers = {
				directory = {
					{ "indent" },
					{ "icon" },
					{ "current_filter" },
					{
						"container",
						content = {
							{ "name", zindex = 10 },
							{
								"symlink_target",
								zindex = 10,
								highlight = "NeoTreeSymbolicLinkTarget",
							},
							{ "clipboard", zindex = 10 },
							{
								"diagnostics",
								errors_only = true,
								zindex = 20,
								align = "right",
								hide_when_expanded = true,
							},
							{ "git_status", zindex = 10, align = "right", hide_when_expanded = true },
							{ "file_size", zindex = 10, align = "right" },
							{ "type", zindex = 10, align = "right" },
							{ "last_modified", zindex = 10, align = "right" },
							{ "created", zindex = 10, align = "right" },
						},
					},
				},
				file = {
					{ "indent" },
					{ "icon" },
					{
						"container",
						content = {
							{
								"name",
								zindex = 10,
							},
							{
								"symlink_target",
								zindex = 10,
								highlight = "NeoTreeSymbolicLinkTarget",
							},
							{ "clipboard", zindex = 10 },
							{ "bufnr", zindex = 10 },
							{ "modified", zindex = 20, align = "right" },
							{ "diagnostics", zindex = 20, align = "right" },
							{ "git_status", zindex = 10, align = "right" },
							{ "file_size", zindex = 10, align = "right" },
							{ "type", zindex = 10, align = "right" },
							{ "last_modified", zindex = 10, align = "right" },
							{ "created", zindex = 10, align = "right" },
						},
					},
				},
				message = {
					{ "indent", with_markers = false },
					{ "name", highlight = "NeoTreeMessage" },
				},
				terminal = {
					{ "indent" },
					{ "icon" },
					{ "name" },
					{ "bufnr" },
				},
			},
			nesting_rules = {},
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
				async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
				-- "always" means directory scans are always async.
				-- "never"  means directory scans are never async.
				scan_mode = "shallow", -- "shallow": Don't scan into directories to detect possible empty directory a priori
				-- "deep": Scan into directories to detect empty or grouped empty directories a priori.
				bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
				cwd_target = {
					sidebar = "tab", -- sidebar is when position = left or right
					current = "window", -- current is when position = current
				},
				-- check gitignore status for files/directories when searching.
				-- setting this to false will speed up searches, but gitignored
				-- items won't be marked if they are visible.
				check_gitignore_in_search = true,
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
					children_inherit_highlights = true, -- whether children of filtered parents should inherit their parent's highlight group
					show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_ignored = true, -- hide files that are ignored by other gitignore-like files
					-- other gitignore-like files, in descending order of precedence.
					ignore_files = {
						".neotreeignore",
						".ignore",
						-- ".rgignore"
					},
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						--"node_modules",
					},
					hide_by_pattern = { -- uses glob style patterns
						--"*.meta",
						--"*/src/*/tsconfig.json"
					},
					always_show = { -- remains visible even if other settings would normally hide it
						--".gitignored",
					},
					always_show_by_pattern = { -- uses glob style patterns
						--".env*",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						--".DS_Store",
						--"thumbs.db"
					},
					never_show_by_pattern = { -- uses glob style patterns
						--".null-ls_*",
					},
				},
				find_by_full_path_words = false, -- `false` means it only searches the tail of a path.
				-- `true` will change the filter into a full path
				-- search with space as an implicit ".*", so
				-- `fi init`
				-- will match: `./sources/filesystem/init.lua
				--find_command = "fd", -- this is determined automatically, you probably don't need to set it
				--find_args = {  -- you can specify extra args to pass to the find command.
				--  fd = {
				--  "--exclude", ".git",
				--  "--exclude",  "node_modules"
				--  }
				--},
				---- or use a function instead of list of strings
				--find_args = function(cmd, path, search_term, args)
				--  if cmd ~= "fd" then
				--    return args
				--  end
				--  --maybe you want to force the filter to always include hidden files:
				--  table.insert(args, "--hidden")
				--  -- but no one ever wants to see .git files
				--  table.insert(args, "--exclude")
				--  table.insert(args, ".git")
				--  -- or node_modules
				--  table.insert(args, "--exclude")
				--  table.insert(args, "node_modules")
				--  --here is where it pays to use the function, you can exclude more for
				--  --short search terms, or vary based on the directory
				--  if string.len(search_term) < 4 and path == "/home/cseickel" then
				--    table.insert(args, "--exclude")
				--    table.insert(args, "Library")
				--  end
				--  return args
				--end,
				group_empty_dirs = false, -- when true, empty folders will be grouped together
				search_limit = 50, -- max number of search results when using filters
				follow_current_file = {
					enabled = false, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
				-- in whatever position is specified in window.position
				-- "open_current",-- netrw disabled, opening a directory opens within the
				-- window like netrw would, regardless of window.position
				-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
				use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
				-- instead of relying on nvim autocmd events.
			},
			buffers = {
				bind_to_cwd = true,
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--              -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				group_empty_dirs = true, -- when true, empty directories will be grouped together
				show_unloaded = false, -- When working with sessions, for example, restored but unfocused buffers
				-- are mark as "unloaded". Turn this on to view these unloaded buffer.
				terminals_first = false, -- when true, terminals will be listed before file buffers
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["d"] = "buffer_delete",
						["bd"] = "buffer_delete",
						["i"] = "show_file_details", -- see `:h neo-tree-file-actions` for options to customize the window.
						["b"] = "rename_basename",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					},
				},
			},
			git_status = {
				window = {
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["gU"] = "git_undo_last_commit",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
						["i"] = "show_file_details", -- see `:h neo-tree-file-actions` for options to customize the window.
						["b"] = "rename_basename",
						["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						["oc"] = { "order_by_created", nowait = false },
						["od"] = { "order_by_diagnostics", nowait = false },
						["om"] = { "order_by_modified", nowait = false },
						["on"] = { "order_by_name", nowait = false },
						["os"] = { "order_by_size", nowait = false },
						["ot"] = { "order_by_type", nowait = false },
					},
				},
			},
			document_symbols = {
				follow_cursor = false,
				client_filters = "first",
				renderers = {
					root = {
						{ "indent" },
						{ "icon", default = "C" },
						{ "name", zindex = 10 },
					},
					symbol = {
						{ "indent", with_expanders = true },
						{ "kind_icon", default = "?" },
						{
							"container",
							content = {
								{ "name", zindex = 10 },
								{ "kind_name", zindex = 20, align = "right" },
							},
						},
					},
				},
				window = {
					mappings = {
						["<cr>"] = "jump_to_symbol",
						["o"] = "jump_to_symbol",
						["A"] = "noop", -- also accepts the config.show_path and config.insert_as options.
						["d"] = "noop",
						["y"] = "noop",
						["x"] = "noop",
						["p"] = "noop",
						["c"] = "noop",
						["m"] = "noop",
						["a"] = "noop",
						["/"] = "filter",
						["f"] = "filter_on_submit",
					},
				},
				custom_kinds = {
					-- define custom kinds here (also remember to add icon and hl group to kinds)
					-- ccls
					-- [252] = 'TypeAlias',
					-- [253] = 'Parameter',
					-- [254] = 'StaticMethod',
					-- [255] = 'Macro',
				},
				kinds = {
					Unknown = { icon = "?", hl = "" },
					Root = { icon = "", hl = "NeoTreeRootName" },
					File = { icon = "󰈙", hl = "Tag" },
					Module = { icon = "", hl = "Exception" },
					Namespace = { icon = "󰌗", hl = "Include" },
					Package = { icon = "󰏖", hl = "Label" },
					Class = { icon = "󰌗", hl = "Include" },
					Method = { icon = "", hl = "Function" },
					Property = { icon = "󰆧", hl = "@property" },
					Field = { icon = "", hl = "@field" },
					Constructor = { icon = "", hl = "@constructor" },
					Enum = { icon = "󰒻", hl = "@number" },
					Interface = { icon = "", hl = "Type" },
					Function = { icon = "󰊕", hl = "Function" },
					Variable = { icon = "", hl = "@variable" },
					Constant = { icon = "", hl = "Constant" },
					String = { icon = "󰀬", hl = "String" },
					Number = { icon = "󰎠", hl = "Number" },
					Boolean = { icon = "", hl = "Boolean" },
					Array = { icon = "󰅪", hl = "Type" },
					Object = { icon = "󰅩", hl = "Type" },
					Key = { icon = "󰌋", hl = "" },
					Null = { icon = "", hl = "Constant" },
					EnumMember = { icon = "", hl = "Number" },
					Struct = { icon = "󰌗", hl = "Type" },
					Event = { icon = "", hl = "Constant" },
					Operator = { icon = "󰆕", hl = "Operator" },
					TypeParameter = { icon = "󰊄", hl = "Type" },

					-- ccls
					-- TypeAlias = { icon = ' ', hl = 'Type' },
					-- Parameter = { icon = ' ', hl = '@parameter' },
					-- StaticMethod = { icon = '󰠄 ', hl = 'Function' },
					-- Macro = { icon = ' ', hl = 'Macro' },
				},
			},
			example = {
				renderers = {
					custom = {
						{ "indent" },
						{ "icon", default = "C" },
						{ "custom" },
						{ "name" },
					},
				},
				window = {
					mappings = {
						["<cr>"] = "toggle_node",
						["<C-e>"] = "example_command",
						["d"] = "show_debug_info",
					},
				},
			},
		},
	},
}
