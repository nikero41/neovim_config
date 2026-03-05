---@type LazySpec
return {
	{
		"p00f/clangd_extensions.nvim",
		init = function()
			require("snacks").keymap.set("n", "<leader>lw", vim.cmd.ClangdSwitchSourceHeader, {
				desc = "Switch source/header file",
				lsp = { name = "clangd" },
			})

			local group = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = group,
				callback = function(args)
					if vim.lsp.get_client_by_id(args.data.client_id).name ~= "clangd" then return end
					require("clangd_extensions")
					vim.api.nvim_del_augroup_by_name("clangd_extensions")
				end,
			})
		end,
	},
	{
		"Civitasv/cmake-tools.nvim",
		ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		opts = {},
	},
}
