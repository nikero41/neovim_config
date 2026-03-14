---@module "nui.tree"

---@type LazySpec
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
		"antosha417/nvim-lsp-file-operations",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
		main = "lsp-file-operations",
		opts = {},
		config = function(plugin, opts)
			require(plugin.main).setup(opts)
			vim.lsp.config("*", { capabilities = require(plugin.main).default_capabilities() })
		end,
		init = function(plugin)
			require("nikero.plugin_helpers"):after_load(
				{ "neo-tree.nvim" },
				function() require("lazy").load({ plugins = { plugin.name } }) end
			)
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false, -- neo-tree will lazily load itself
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
		---@module "neo-tree"
		---@type neotree.Config
		opts = {
			sources = { "filesystem" },
			close_if_last_window = true,
			enable_cursor_hijack = true,
			popup_border_style = "", -- "" to use 'winborder'
			use_popups_for_input = true,
			auto_clean_after_session_restore = true,
			source_selector = {
				winbar = true,
				content_layout = "center",
				show_scrolled_off_parent_node = true,
				truncation_character = "…",
			},
			event_handlers = {
				-- TODO:
				-- {
				-- 	event = "neo_tree_buffer_enter",
				-- 	handler = function() vim.cmd("highlight! Cursor blend=100") end,
				-- },
				-- {
				-- 	event = "neo_tree_buffer_leave",
				-- 	handler = function() vim.cmd("highlight! Cursor guibg=#5f87af blend=0") end,
				-- },
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
				{
					event = "neo_tree_buffer_enter",
					handler = function() vim.opt_local.foldcolumn = "0" end,
				},
			},
			default_component_configs = {
				container = { enable_character_fade = true },
				indent = {
					padding = 0,
					with_markers = true,
					with_expanders = true,
					expander_collapsed = require("icons").FoldClosed,
					expander_expanded = require("icons").FoldOpened,
				},
				icon = {
					folder_closed = require("icons").FolderClosed,
					folder_open = require("icons").FolderOpen,
					-- TODO:
					-- folder_empty = require("icons").FolderEmpty,
					-- folder_empty_open = require("icons").FolderEmptyOpen,
					folder_empty = "󰉖",
					folder_empty_open = "󰷏",
					use_filtered_colors = true,
					default = require("icons").DefaultFile,
				},
				modified = { symbol = require("icons").FileModified },
				git_status = {
					symbols = {
						added = require("icons").GitAdd,
						deleted = require("icons").GitDelete,
						modified = require("icons").GitChange,
						renamed = require("icons").GitRenamed,
						untracked = require("icons").GitUntracked,
						ignored = require("icons").GitIgnored,
						unstaged = "", -- require("icons").GitUnstaged,
						staged = require("icons").GitStaged,
						conflict = require("icons").GitConflict,
					},
				},
			},
			commands = {
				system_open = function(state) vim.ui.open(state.tree:get_node():get_id()) end,
				parent_or_close = function(state)
					local node = assert(state.tree:get_node())
					if node:has_children() and node:is_expanded() then
						state.commands.toggle_node(state)
					else
						require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
					end
				end,
				child_or_open = function(state)
					local node = assert(state.tree:get_node())
					if not node:has_children() then
						state.commands.open(state)
						return
					end

					if not node:is_expanded() then
						state.commands.toggle_node(state)
						return
					end

					-- if expanded and has children, seleect the next child
					if node.type == "file" then
						state.commands.open(state)
					else
						require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
					end
				end,
				copy_selector = function(state)
					local node = assert(state.tree:get_node())
					local filepath = node:get_id()
					local filename = node.name
					local modify = vim.fn.fnamemodify

					local vals = {
						["BASENAME"] = modify(filename, ":r"),
						["EXTENSION"] = modify(filename, ":e"),
						["FILENAME"] = filename,
						["PATH (CWD)"] = modify(filepath, ":."),
						["PATH (HOME)"] = modify(filepath, ":~"),
						["PATH"] = filepath,
						["URI"] = vim.uri_from_fname(filepath),
					}

					local options = vim.tbl_filter(
						function(val) return vals[val] ~= "" end,
						vim.tbl_keys(vals)
					)
					if vim.tbl_isempty(options) then
						vim.notify("No values to copy", vim.log.levels.WARN)
						return
					end
					table.sort(options)
					vim.ui.select(options, {
						prompt = "Choose to copy to clipboard:",
						format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
					}, function(choice)
						local result = vals[choice]
						if result then
							vim.notify(("Copied: `%s`"):format(result))
							vim.fn.setreg("+", result)
						end
					end)
				end,
			},

			window = {
				popup = { title = function(state) return state.name:gsub("^%l", string.upper) end },
				mappings = {
					["<cr>"] = { "open", config = { expand_nested_files = true } }, -- expand nested file takes precedence
					["<S-CR>"] = "system_open",
					["h"] = "parent_or_close",
					["l"] = "child_or_open",
					["L"] = "focus_preview",
					["<C-x>"] = "open_split",
					["<C-v>"] = "open_vsplit",
					["<C-X>"] = "split_with_window_picker",
					["<C-V>"] = "vsplit_with_window_picker",
					["C"] = "close_all_subnodes",
					["Z"] = "expand_all_subnodes",
					["Y"] = "copy_selector",
					["a"] = { "add", config = { show_path = "relative" } },
					["A"] = { "add_directory", config = { show_path = "relative" } }, -- also accepts the config.show_path and config.insert_as options.
				},
			},
			filesystem = {
				window = {
					mappings = {
						["/"] = { "fuzzy_finder", config = { keep_filter_on_submit = true } },
						["<esc>"] = "clear_filter",
					},
					fuzzy_finder_mappings = {
						["<C-J>"] = "move_cursor_down",
						["<C-K>"] = "move_cursor_up",
						["<C-w>"] = { "<C-S-w>", raw = true },
					},
				},
				filtered_items = {
					force_visible_in_empty_folder = true,
					show_hidden_count = true,
					hide_by_name = { ".DS_Store", "thumbs.db", "node_modules" },
					always_show_by_pattern = { ".env*" },
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("BufEnter", {
				desc = "Open Neo-Tree on startup with directory",
				group = vim.api.nvim_create_augroup("neo-tree-directory-startup", { clear = true }),
				callback = function(args)
					if package.loaded["neo-tree"] then return true end

					local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
					if stats and stats.type == "directory" then
						require("lazy").load({ plugins = { "neo-tree.nvim" } })
						pcall(
							vim.api.nvim_exec_autocmds,
							"BufEnter",
							{ group = "NeoTree_NetrwDeferred", buffer = args.buf }
						)
						return true
					end
				end,
			})
		end,
	},
}
