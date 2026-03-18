---@type LazySpec
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{
			"<leader>.",
			function() Snacks.scratch() end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>fS",
			function() Snacks.scratch.select() end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>uD",
			function() require("snacks.notifier").hide() end,
			desc = "Dismiss notifications",
		},
		{
			"[[",
			function() Snacks.words.jump(-vim.v.count1) end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
		{
			"]]",
			function() Snacks.words.jump(vim.v.count1) end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"<Leader>uZ",
			function() require("snacks").toggle.zen():toggle() end,
			desc = "Toggle zen mode",
		},
	},
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		image = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { folds = { open = true, git_hl = true } },
		indent = {
			indent = { char = "▏" },
			scope = { char = "▏" },
			animate = { enabled = false },
		},
		input = {
			enabled = true,
			win = {
				relative = "cursor",
				title_pos = "left",
				row = -3,
				col = -5,
			},
		},
		notifier = {
			icons = {
				debug = require("icons").Debugger,
				error = require("icons").DiagnosticError,
				info = require("icons").DiagnosticInfo,
				trace = require("icons").DiagnosticHint,
				warn = require("icons").DiagnosticWarn,
			},
			filter = function(notification)
				local pattern_to_hide = "%[supermaven%-nvim%] File is too large to send"
				return string.match(notification.msg, pattern_to_hide) == nil
			end,
		},
		scope = { enabled = true },
		words = { enabled = true },
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			desc = "Load snacks.nvim functions",
			group = vim.api.nvim_create_augroup("snacks-lazy", { clear = true }),
			callback = function()
				_G.dd = function(...) Snacks.debug.inspect(...) end
				_G.bt = function() Snacks.debug.backtrace() end
				vim._print = function(_, ...) Snacks.debug.inspect(...) end

				Snacks.toggle.inlay_hints():map("<leader>uh")
			end,
			once = true,
		})
	end,
}
