if true then return {} end

---@type LazySpec
return {
	{
		"sindrets/diffview.nvim",
		opts = { view = { merge_tool = { layout = "diff4_mixed" } } },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		event = "User File",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
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
			return vim.tbl_extend("force", opts, {
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
}
