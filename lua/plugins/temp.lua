-- TODO: cmp, dap, diagnostic, heirline, neo-tree, none-ls, ui
if true then return {} end

---@type LazySpec
return {
	{
		"ThePrimeagen/refactoring.nvim",
		event = "User AstroFile",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
	{
		"codethread/qmk.nvim",
		event = "BufRead *.keymap",
		opts = {
			name = "corne",
			variant = "zmk",
			layout = {
				"x x x x x x _ x x x x x x",
				"x x x x x x _ x x x x x x",
				"x x x x x x _ x x x x x x",
				"_ _ _ x x x _ x x x _ _ _",
			},
		},
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"rcasia/neotest-bash",
			"fredrikaverpil/neotest-golang",
		},
		opts = function(_, opts)
			return require("astrocore").extend_tbl(opts, {
				adapters = {
					require("neotest-jest")(),
					require("neotest-vitest")(),
					require("rustaceanvim.neotest")(),
					require("neotest-bash")(),
					require("neotest-golang")(),
				},
			})
		end,
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

			for _, language in ipairs(require("filetypes").javascript) do
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
