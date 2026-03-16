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
}
