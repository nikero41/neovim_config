require("options")
require("keymaps")

local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

if not pcall(require, "lazy") then
	vim.api.nvim_echo(
		{ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
		true,
		{}
	)
	vim.fn.getchar()
	vim.cmd.quit()
end

require("lazy").setup({
	-- -- LSP Plugins
	-- {
	-- 				-- The following two autocommands are used to highlight references of the
	-- 				-- word under your cursor when your cursor rests there for a little while.
	-- 				--    See `:help CursorHold` for information about when this is executed
	-- 				--
	-- 				-- When you move your cursor, the highlights will be cleared (the second autocommand).
	-- 				local client = vim.lsp.get_client_by_id(event.data.client_id)
	-- 				if client and client:supports_method("textDocument/documentHighlight", event.buf) then
	-- 					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
	-- 					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	-- 						buffer = event.buf,
	-- 						group = highlight_augroup,
	-- 						callback = vim.lsp.buf.document_highlight,
	-- 					})
	--
	-- 					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	-- 						buffer = event.buf,
	-- 						group = highlight_augroup,
	-- 						callback = vim.lsp.buf.clear_references,
	-- 					})
	--
	-- 					vim.api.nvim_create_autocmd("LspDetach", {
	-- 						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
	-- 						callback = function(event2)
	-- 							vim.lsp.buf.clear_references()
	-- 							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
	-- 						end,
	-- 					})
	-- 				end
	--
	-- 				-- The following code creates a keymap to toggle inlay hints in your
	-- 				-- code, if the language server you are using supports them
	-- 				--
	-- 				-- This may be unwanted, since they displace some of your code
	-- 				if client and client:supports_method("textDocument/inlayHint", event.buf) then
	-- 					map(
	-- 						"<leader>th",
	-- 						function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })) end,
	-- 						"[T]oggle Inlay [H]ints"
	-- 					)
	-- 				end
	-- 			end,
	-- 		})
	--
	-- 		-- LSP servers and clients are able to communicate to each other what features they support.
	-- 		--  By default, Neovim doesn't support everything that is in the LSP specification.
	-- 		--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
	-- 		--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
	-- 		local capabilities = require("blink.cmp").get_lsp_capabilities()
	--
	-- 		-- Enable the following language servers
	-- 		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
	-- 		--  See `:help lsp-config` for information about keys and how to configure
	-- 		local servers = {
	-- 			-- clangd = {},
	-- 			-- gopls = {},
	-- 			-- pyright = {},
	-- 			-- rust_analyzer = {},
	-- 			--
	-- 			-- Some languages (like typescript) have entire language plugins that can be useful:
	-- 			--    https://github.com/pmizio/typescript-tools.nvim
	-- 			--
	-- 			-- But for many setups, the LSP (`ts_ls`) will work just fine
	-- 			-- ts_ls = {},
	-- 		}
	--
	-- 		-- Ensure the servers and tools above are installed
	-- 		--
	-- 		-- To check the current status of installed tools and/or manually install
	-- 		-- other tools, you can run
	-- 		--    :Mason
	-- 		--
	-- 		-- You can press `g?` for help in this menu.
	-- 		local ensure_installed = vim.tbl_keys(servers or {})
	-- 		vim.list_extend(ensure_installed, {
	-- 			"lua_ls", -- Lua Language server
	-- 			"stylua", -- Used to format Lua code
	-- 			-- You can add other tools here that you want Mason to install
	-- 		})
	--
	-- 		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	--
	-- 		for name, server in pairs(servers) do
	-- 			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
	-- 			vim.lsp.config(name, server)
	-- 			vim.lsp.enable(name)
	-- 		end
	--
	-- 		-- Special Lua Config, as recommended by neovim help docs
	-- 		vim.lsp.config("lua_ls", {
	-- 			on_init = function(client)
	-- 				if client.workspace_folders then
	-- 					local path = client.workspace_folders[1].name
	-- 					if
	-- 						path ~= vim.fn.stdpath("config")
	-- 						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
	-- 					then
	-- 						return
	-- 					end
	-- 				end
	--
	-- 				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
	-- 					runtime = {
	-- 						version = "LuaJIT",
	-- 						path = { "lua/?.lua", "lua/?/init.lua" },
	-- 					},
	-- 					workspace = {
	-- 						checkThirdParty = false,
	-- 						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
	-- 						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
	-- 						library = vim.api.nvim_get_runtime_file("", true),
	-- 					},
	-- 				})
	-- 			end,
	-- 			settings = {
	-- 				Lua = {},
	-- 			},
	-- 		})
	-- 		vim.lsp.enable("lua_ls")
	-- 	end,
	-- },
	spec = {
		{ import = "plugins/snacks" },
		{ import = "plugins" },
		{ import = "plugins/language" },
	},
	defaults = { lazy = true },
	install = { colorscheme = { require("colorscheme") } },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = { border = vim.o.winborder },
})

vim.cmd.colorscheme(require("colorscheme"))
require("highlights")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
