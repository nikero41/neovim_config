---@type LazySpec
return {
	{
		"L3MON4D3/LuaSnip",
		config = function(_, opts)
			require("luasnip").setup(opts)
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			})
		end,
	},
	{
		"Saghen/blink.cmp",
		dependencies = {
			{ "disrupted/blink-cmp-conventional-commits" },
			{ "Kaiser-Yang/blink-cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
			{
				"David-Kunz/cmp-npm",
				dependencies = { "nvim-lua/plenary.nvim" },
				opts = {},
			},
			{ "Saghen/blink.compat", version = "*", opts = {} },
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
				["<C-e>"] = { "fallback" },
				["<C-space>"] = { "show", "hide" },
			},
			signature = { enabled = false },
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
				},
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				keyword = { range = "full" },
				menu = {
					scrolloff = 1,
					max_height = 20,
					border = "rounded",
					scrollbar = true,
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder",
					draw = {
						padding = 1,
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
							{ "kind", "source_name", gap = 1 },
						},
					},
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder",
					},
				},
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
					show_on_accept_on_trigger_character = true,
					show_on_insert_on_trigger_character = true,
				},
			},
			cmdline = {
				completion = { ghost_text = { enabled = true } },
			},
			fuzzy = {
				sorts = { "exact", "score", "sort_text" },
			},
		},
	},
}
