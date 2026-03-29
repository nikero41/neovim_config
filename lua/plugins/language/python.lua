---@type LazySpec
return {
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		config = function(_, opts)
			local path = vim.fn.exepath("debugpy-adapter")
			if path == "" then path = vim.fn.exepath("python") end
			if path == "" then path = vim.fn.exepath("python3") end
			require("dap-python").setup(path, opts)
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		enabled = vim.fn.executable("fd") == 1
			or vim.fn.executable("fdfind") == 1
			or vim.fn.executable("fd-find") == 1,
		cmd = "VenvSelect",
		keys = {
			{ "<leader>lv", vim.cmd.VenvSelect, desc = "Select VirtualEnv", ft = "python" },
		},
		opts = {},
	},
}
