---@type LazySpec
return {
	{
		"nanotee/sqls.nvim",
		init = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "Load sqls.nvim with sqls",
				group = vim.api.nvim_create_augroup("sqls.nvim", { clear = true }),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					if client.name == "sqls" then require("sqls").on_attach(client, args.buf) end
				end,
			})
		end,
	},
}
