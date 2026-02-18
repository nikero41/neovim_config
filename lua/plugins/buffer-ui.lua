---@type LazySpec
return {
	{
		"petertriho/nvim-scrollbar",
		opts = {
			excluded_buftypes = { "nofile" },
			excluded_filetypes = {
				"prompt",
				"neo-tree",
				"blink-cmp-menu",
				"blink-cmp-documentation",
				"blink-cmp-signature",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			mode = "topline",
			separator = "",
			max_lines = 8,
			trim_scope = "outer",
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { blink = { enabled = true } },
			heading = {
				render_modes = true,
				border = true,
				border_virtual = true,
			},
			paragraph = { render_modes = true },
			code = {
				render_modes = true,
				width = "block",
				left_pad = 2,
				right_pad = 2,
			},
			dash = { render_modes = true },
			bullet = { render_modes = true },
			checkbox = {
				render_modes = true,
				unchecked = { icon = "✘ " },
				checked = {
					icon = "✔ ",
					scope_highlight = "@markup.strikethrough",
				},
				custom = {
					todo = {
						rendered = "◯ ",
						scope_highlight = "@markup.strikethrough",
					},
				},
			},
			quote = { render_modes = true },
			pipe_table = { render_modes = true },
			link = { render_modes = true },
			indent = {
				enabled = true,
				render_modes = true,
				per_level = 2,
				skip_heading = true,
			},
			overrides = {
				buftype = {
					nofile = {
						code = {
							left_pad = 0,
							language_icon = false,
							language_name = false,
						},
					},
				},
			},
		},
	},
	{
		"malbertzard/inline-fold.nvim",
		cmd = { "InlineFoldToggle" },
		opts = function(_, opts)
			opts.defaultPlaceholder = "…"

			if not opts.queries then opts.queries = {} end

			opts.queries.html = require("astrocore").extend_tbl(opts.queries.html, {
				{ pattern = 'class="([^"]*)"' },
				{ pattern = 'href="(.-)"' },
				{ pattern = 'src="(.-)"' },
			})

			for _, language in ipairs(require("utils.constants").filetype.javascript) do
				opts.queries[language] = {
					{ pattern = 'className="([^"]*)"' },
					{ pattern = 'href="(.-)"' },
					{ pattern = 'src="(.-)"' },
				}
			end

			return opts
		end,
	},
}
