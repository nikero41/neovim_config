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
		input = { enabled = true },
		notifier = {
			icons = {
				debug = require("icons").tools.debugger,
				error = require("icons").diagnostics.error,
				info = require("icons").diagnostics.info,
				trace = require("icons").diagnostics.hint,
				warn = require("icons").diagnostics.warn,
			},
			filter = function(notification)
				local pattern_to_hide = "%[supermaven%-nvim%] File is too large to send"
				return string.match(notification.msg, pattern_to_hide) == nil
			end,
		},
		scope = { enabled = true },
		toggle = { icon = "" },
		words = { enabled = true },
		zen = {
			toggles = { dim = false, inlay_hints = false },
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			desc = "Load snacks.nvim functions",
			group = vim.api.nvim_create_augroup("snacks-lazy", { clear = true }),
			callback = function()
				_G.dd = function(...) Snacks.debug.inspect(...) end
				_G.bt = function() Snacks.debug.backtrace() end
				---@diagnostic disable-next-line: duplicate-set-field
				vim._print = function(_, ...) Snacks.debug.inspect(...) end

				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.zen():map("<leader>uZ")
				Snacks.toggle.zoom():map("<leader>uz")
			end,
			once = true,
		})
	end,
}
