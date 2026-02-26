---@type LazySpec
return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { { "rafamadriz/friendly-snippets", lazy = true } },
		version = "v2.*",
		build = "make install_jsregexp",
		opts = {
			history = true,
			delete_check_events = "TextChanged",
			region_check_events = "CursorMoved",
		},
		config = function(_, opts)
			-- require("luasnip").config.setup(opts)
			require("luasnip").setup(opts)
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			})
		end,
	},
	{
		"David-Kunz/cmp-npm",
		event = "BufRead package.json",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "Saghen/blink.compat", version = "*", opts = {} },
		},
		opts = {},
	},
	{ "disrupted/blink-cmp-conventional-commits", ft = "gitcommit" },
	{ "Kaiser-Yang/blink-cmp-git", ft = "gitcommit", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = { "InsertEnter", "CmdlineEnter" },
		build = "cargo build --release",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
				["<C-e>"] = { "fallback" },
				["<C-space>"] = { "show", "hide" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-N>"] = { "select_next", "show" },
				["<C-P>"] = { "select_prev", "show" },
				["<C-J>"] = { "select_next", "fallback" },
				["<C-K>"] = { "select_prev", "fallback" },
				["<C-U>"] = { "scroll_documentation_up", "fallback" },
				["<C-D>"] = { "scroll_documentation_down", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = {
					"snippet_forward",
					function()
						if vim.g.ai_accept then return vim.g.ai_accept() end
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					"snippet_backward",
					function(cmp)
						if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
					end,
					"fallback",
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "npm", "buffer" },
				per_filetype = {
					gitcommit = { "conventional_commits", "git", "npm", "path", "buffer" },
				},
				providers = {
					git = {
						name = "Git",
						module = "blink-cmp-git",
					},
					conventional_commits = {
						name = "Conventional Commits",
						module = "blink-cmp-conventional-commits",
					},
					npm = {
						name = "npm",
						module = "blink.compat.source",
						enabled = function() return vim.fn.expand("%:t") == "package.json" end,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			snippets = { preset = "luasnip" },
			completion = {
				accept = { auto_brackets = { enabled = true } },
				keyword = { range = "full" },
				menu = {
					scrolloff = 1,
					max_height = 20,
					border = vim.o.winborder,
					scrollbar = true,
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder",
					draw = {
						treesitter = { "lsp" },
						padding = 1,
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
							{ "kind", "source_name", gap = 1 },
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					window = {
						border = vim.o.winborder,
						winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder",
					},
				},
				trigger = {
					show_on_backspace = true,
					show_in_snippet = true,
					show_on_keyword = true,
					show_on_trigger_character = true,
					show_on_accept_on_trigger_character = true,
					show_on_insert_on_trigger_character = true,
				},
			},
			signature = {
				enabled = false,
				window = {
					border = vim.o.winborder,
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
				},
			},
			cmdline = {
				completion = { ghost_text = { enabled = true } },
				keymap = {
					["<End>"] = { "hide", "fallback" },
				},
			},
			appearance = { nerd_font_variant = "mono" },
			fuzzy = { sorts = { "exact", "score", "sort_text" } },
		},
	},
}
