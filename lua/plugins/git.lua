---@type LazySpec
return {
	{
		"lewis6991/gitsigns.nvim",
		opts = function(_, opts)
			vim.notify(vim.inspect(opts), nil, { title = "🪚 opts", ft = "lua" })
			local original_on_attach = opts.on_attach
			opts.on_attach = function(bufnr)
				-- run default on_attach function
				if original_on_attach then original_on_attach(bufnr) end
				-- continue with customizations such as deleting mappings
				vim.keymap.del("n", "<Leader>gL", { buffer = bufnr })
			end
		end,
	},
	{
		"FabijanZulj/blame.nvim",
		cmd = { "BlameToggle" },
		keys = { { "<Leader>gB", vim.cmd.BlameToggle, desc = "Toggle git blame" } },
		opts = { date_format = "%d/%m/%Y" },
	},
}
