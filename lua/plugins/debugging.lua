---@type LazySpec
return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-jest",
			"arthur944/neotest-bun",
			"marilari88/neotest-vitest",
			"fredrikaverpil/neotest-golang",
			"mrcjkb/rustaceanvim",
		},
		keys = {
			{
				"<leader>Tt",
				function() require("neotest").run.run() end,
				desc = "Run test",
			},
			{
				"<leader>Td",
				---@diagnostic disable-next-line: missing-fields
				function() require("neotest").run.run({ strategy = "dap" }) end,
				desc = "Debug test",
			},
			{
				"<leader>Tf",
				function() require("neotest").run.run(vim.fn.expand("%")) end,
				desc = "Run all tests in file",
			},
			{
				"<leader>Tp",
				function() require("neotest").run.run(vim.fn.getcwd()) end,
				desc = "Run all tests in project",
			},
			{
				"<leader>T<CR>",
				function() require("neotest").summary.toggle() end,
				desc = "Test Summary",
			},
			{
				"<leader>To",
				function() require("neotest").output.open() end,
				desc = "Output hover",
			},
			{
				"<leader>TO",
				function() require("neotest").output_panel.toggle() end,
				desc = "Output window",
			},
			{
				"]T",
				function() require("neotest").jump.next() end,
				desc = "Next test",
			},
			{
				"[T",
				function() require("neotest").jump.prev() end,
				desc = "Previous test",
			},

			{
				"<leader>TWt",
				function() require("neotest").watch.toggle() end,
				desc = "Toggle watch test",
			},
			{
				"<leader>TWf",
				function() require("neotest").watch.toggle(vim.fn.expand("%")) end,
				desc = "Toggle watch all test in file",
			},
			{
				"<leader>TWp",
				function() require("neotest").watch.toggle(vim.fn.getcwd()) end,
				desc = "Toggle watch all tests in project",
			},
			{
				"<leader>TWS",
				function()
					---@diagnostic disable-next-line: missing-parameter
					require("neotest").watch.stop()
				end,
				desc = "Stop all watches",
			},
		},
		---@param opts neotest.Config
		---@return neotest.Config
		opts = function(_, opts)
			opts.adapters = {
				require("neotest-jest"),
				require("neotest-vitest"),
				require("rustaceanvim.neotest"),
				require("neotest-golang"),
				require("neotest-bun"),
			}

			return opts
		end,
		config = function(_, opts)
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						-- Replace newline and tab characters with space for more compact diagnostics
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			require("neotest").setup(opts)
		end,
	},
}
