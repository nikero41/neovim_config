---@type LazySpec
return {
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		cmd = "GoInstallDeps",
		build = function()
			if not require("lazy.core.config").spec.plugins["mason.nvim"] then
				vim.notify("Installing go dependencies...")
				vim.cmd.GoInstallDeps()
			end
		end,
		---@module "gopher"
		---@type gopher.Config
		---@diagnostic disable-next-line: missing-fields
		opts = {},
	},
}
