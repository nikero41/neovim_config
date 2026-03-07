---@type LazySpec
return {
	{
		"mfussenegger/nvim-dap-python",
		-- dependencies = "mfussenegger/nvim-dap",
		ft = "python",
		config = function(_, opts)
			local path = vim.fn.exepath("debugpy-adapter")
			if path == "" then path = vim.fn.exepath("python") end
			require("dap-python").setup(path, opts)
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		enabled = vim.fn.executable("fd") == 1
			or vim.fn.executable("fdfind") == 1
			or vim.fn.executable("fd-find") == 1,
		cmd = "VenvSelect",
		opts = {},
		init = function()
			require("snacks").keymap.set(
				"n",
				"<leader>lv",
				vim.cmd.VenvSelect,
				{ ft = "python", desc = "Select VirtualEnv" }
			)
		end,
	},
}
