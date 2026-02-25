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
	-- stylua: ignore
	vim.api.nvim_echo(
		{ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
		true, {})
	vim.fn.getchar()
	vim.cmd.quit()
end

require("keymaps")

require("lazy").setup({
	-- { -- Adds git related signs to the gutter, as well as utilities for managing changes
	-- 	"lewis6991/gitsigns.nvim",
	-- 	opts = {
	-- 		signs = {
	-- 			add = { text = "+" },
	-- 			change = { text = "~" },
	-- 			delete = { text = "_" },
	-- 			topdelete = { text = "‾" },
	-- 			changedelete = { text = "~" },
	-- 		},
	-- 	},
	-- },
	-- 		-- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
	-- 		-- it is better explained there). This allows easily switching between pickers if you prefer using something else!
	-- 		vim.api.nvim_create_autocmd("LspAttach", {
	-- 			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
	-- 			callback = function(event)
	-- 				local buf = event.buf
	--
	-- 				-- Find references for the word under your cursor.
	-- 				vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
	--
	-- 				-- Jump to the implementation of the word under your cursor.
	-- 				-- Useful when your language has ways of declaring types without an actual implementation.
	-- 				vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
	--
	-- 				-- Jump to the definition of the word under your cursor.
	-- 				-- This is where a variable was first declared, or where a function is defined, etc.
	-- 				-- To jump back, press <C-t>.
	-- 				vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
	--
	-- 				-- Fuzzy find all the symbols in your current document.
	-- 				-- Symbols are things like variables, functions, types, etc.
	-- 				vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
	--
	-- 				-- Fuzzy find all the symbols in your current workspace.
	-- 				-- Similar to document symbols, except searches over your entire project.
	-- 				vim.keymap.set(
	-- 					"n",
	-- 					"gW",
	-- 					builtin.lsp_dynamic_workspace_symbols,
	-- 					{ buffer = buf, desc = "Open Workspace Symbols" }
	-- 				)
	--
	-- 				-- Jump to the type of the word under your cursor.
	-- 				-- Useful when you're not sure what type a variable is and you want to see
	-- 				-- the definition of its *type*, not where it was *defined*.
	-- 				vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "[G]oto [T]ype Definition" })
	-- 			end,
	-- 		})
	--
	-- -- LSP Plugins
	-- {
	-- 	config = function()
	-- 		--  This function gets run when an LSP attaches to a particular buffer.
	-- 		--    That is to say, every time a new file is opened that is associated with
	-- 		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
	-- 		--    function will be executed to configure the current buffer
	-- 		vim.api.nvim_create_autocmd("LspAttach", {
	-- 			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	-- 			callback = function(event)
	-- 				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
	-- 				-- to define small helper and utility functions so you don't have to repeat yourself.
	-- 				--
	-- 				-- In this case, we create a function that lets us more easily define mappings specific
	-- 				-- for LSP related items. It sets the mode, buffer and description for us each time.
	-- 				local map = function(keys, func, desc, mode)
	-- 					mode = mode or "n"
	-- 					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	-- 				end
	--
	-- 				-- Rename the variable under your cursor.
	-- 				--  Most Language Servers support renaming across files, etc.
	-- 				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
	--
	-- 				-- Execute a code action, usually your cursor needs to be on top of an error
	-- 				-- or a suggestion from your LSP for this to activate.
	-- 				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
	--
	-- 				-- WARN: This is not Goto Definition, this is Goto Declaration.
	-- 				--  For example, in C this would take you to the header.
	-- 				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	--
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
	--
	-- { -- Autocompletion
	-- 	"saghen/blink.cmp",
	-- 	event = "VimEnter",
	-- 	version = "1.*",
	-- 	dependencies = {
	-- 		-- Snippet Engine
	-- 		{
	-- 			"L3MON4D3/LuaSnip",
	-- 			version = "2.*",
	-- 			build = (function()
	-- 				-- Build Step is needed for regex support in snippets.
	-- 				-- This step is not supported in many windows environments.
	-- 				-- Remove the below condition to re-enable on windows.
	-- 				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then return end
	-- 				return "make install_jsregexp"
	-- 			end)(),
	-- 			dependencies = {
	-- 				-- `friendly-snippets` contains a variety of premade snippets.
	-- 				--    See the README about individual language/framework/plugin snippets:
	-- 				--    https://github.com/rafamadriz/friendly-snippets
	-- 				-- {
	-- 				--   'rafamadriz/friendly-snippets',
	-- 				--   config = function()
	-- 				--     require('luasnip.loaders.from_vscode').lazy_load()
	-- 				--   end,
	-- 				-- },
	-- 			},
	-- 			opts = {},
	-- 		},
	-- 	},
	-- 	--- @module 'blink.cmp'
	-- 	--- @type blink.cmp.Config
	-- 	opts = {
	-- 		keymap = {
	-- 			-- 'default' (recommended) for mappings similar to built-in completions
	-- 			--   <c-y> to accept ([y]es) the completion.
	-- 			--    This will auto-import if your LSP supports it.
	-- 			--    This will expand snippets if the LSP sent a snippet.
	-- 			-- 'super-tab' for tab to accept
	-- 			-- 'enter' for enter to accept
	-- 			-- 'none' for no mappings
	-- 			--
	-- 			-- For an understanding of why the 'default' preset is recommended,
	-- 			-- you will need to read `:help ins-completion`
	-- 			--
	-- 			-- No, but seriously. Please read `:help ins-completion`, it is really good!
	-- 			--
	-- 			-- All presets have the following mappings:
	-- 			-- <tab>/<s-tab>: move to right/left of your snippet expansion
	-- 			-- <c-space>: Open menu or open docs if already open
	-- 			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
	-- 			-- <c-e>: Hide menu
	-- 			-- <c-k>: Toggle signature help
	-- 			--
	-- 			-- See :h blink-cmp-config-keymap for defining your own keymap
	-- 			preset = "default",
	--
	-- 			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
	-- 			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
	-- 		},
	--
	-- 		appearance = {
	-- 			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
	-- 			-- Adjusts spacing to ensure icons are aligned
	-- 			nerd_font_variant = "mono",
	-- 		},
	--
	-- 		completion = {
	-- 			-- By default, you may press `<c-space>` to show the documentation.
	-- 			-- Optionally, set `auto_show = true` to show the documentation after a delay.
	-- 			documentation = { auto_show = false, auto_show_delay_ms = 500 },
	-- 		},
	--
	-- 		sources = {
	-- 			default = { "lsp", "path", "snippets" },
	-- 		},
	--
	-- 		snippets = { preset = "luasnip" },
	--
	-- 		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
	-- 		-- which automatically downloads a prebuilt binary when enabled.
	-- 		--
	-- 		-- By default, we use the Lua implementation instead, but you may enable
	-- 		-- the rust implementation via `'prefer_rust_with_warning'`
	-- 		--
	-- 		-- See :h blink-cmp-config-fuzzy for more information
	-- 		fuzzy = { implementation = "lua" },
	--
	-- 		-- Shows a signature help window while you type arguments for a function
	-- 		signature = { enabled = true },
	-- 	},
	-- },
	spec = {
		{ import = "plugins/snacks" },
		{ import = "plugins" },
		{ import = "plugins/cmp" },
		{ import = "plugins/language" },
	},
	defaults = { lazy = true },
	install = { colorscheme = { require("colorscheme") } },
	checker = { enabled = false },
	ui = {
		border = vim.o.winborder,
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

vim.cmd.colorscheme(require("colorscheme"))

vim.filetype.add({
	extension = {
		env = "dotenv",
		podspec = "ruby",
		tmux = "tmux",
		gitconfig = "gitconfig",
	},
	filename = {
		[".env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
		[".eslintrc.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
		[".sqlfluff"] = "toml",
		["Podfile"] = "ruby",
		["dot-zshrc"] = "zsh",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
	},
})
