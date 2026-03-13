---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			hint = {
				enable = true,
				arrayIndex = "Disable",
			},
		},
	},
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			local config_path = vim.fs.joinpath(path, ".luarc.json")
			local has_config = vim.loop.fs_stat(config_path) or vim.loop.fs_stat(config_path .. "c")
			if has_config then return end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = { "lua/?.lua", "lua/?/init.lua" },
			},
			workspace = {
				checkThirdParty = true,
				-- -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
				-- --  See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = vim.api.nvim_get_runtime_file("", true),
			},
		})
	end,
}
