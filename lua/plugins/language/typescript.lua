---@type LazySpec
return {
	{
		"axelvc/template-string.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = require("filetypes").javascript,
		opts = {
			jsx_brackets = true,
			remove_template_strings = true,
			restore_quotes = { normal = [["]], jsx = [["]] },
		},
	},
	{
		-- TODO:
		"marilari88/twoslash-queries.nvim",
		ft = require("filetypes").javascript,
		opts = { multi_line = true },
	},
	{
		-- TODO:
		enabled = false,
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		keys = {
			{
				"<leader>ut",
				function()
					vim.notify(require("tailwind-tools.state").conceal.enabled and "classes unfolded" or "classes folded", nil, {
						title = "tailwind-tools",
					})
					require("tailwind-tools.conceal").toggle()
				end,
				desc = "Toggle tailwind classes",
			},
		},
		---@module "tailwind-tools"
		---@type fun(plugin: any, opts: TailwindTools.Option): TailwindTools.Option
		opts = function()
			local patterns = {}
			for _, language in pairs(require("filetypes").javascript) do
				patterns[language] = {
					"clsx%(([^)]+)%)",
					"cn%(([^)]+)%)",
				}
			end

			return {
				keymaps = { smart_increment = { enabled = true } },
				extension = { patterns = patterns },
			}
		end,
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = require("filetypes").javascript,
		opts = { keymaps = { toggle = "gL" } },
	},
}
