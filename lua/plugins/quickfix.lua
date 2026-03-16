---@type LazySpec
return {
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			opts = {
				number = true,
				relativenumber = true,
			},
		},
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		---@module "bqf"
		---@type BqfConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			auto_resize_height = true,
			---@diagnostic disable-next-line: missing-fields
			preview = { border = vim.o.winborder },
		},
		init = function()
			vim.fn.sign_define("BqfSign", { text = " " .. require("icons").Selected, texthl = "BqfSign" })
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>ud", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
		},
		-- TODO:
		---@module "trouble"
		---@type trouble.Config
		opts = {
			focus = true,
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				position = { -2, -2 },
				size = { width = 0.3, height = 0.3 },
				zindex = 200,

				-- when a buffer is not yet loaded, the preview window will be created
				-- in a scratch buffer with only syntax highlighting enabled.
				-- Set to false, if you want the preview to always be a real loaded buffer.
				scratch = true,
			},
		},
		init = function()
			-- TODO:
			vim.api.nvim_create_autocmd("QuickFixCmdPost", {
				callback = function()
					vim.notify("🪚 🔵")
					vim.cmd.Trouble("qflist open")
				end,
			})
		end,
		specs = {
			{
				"folke/snacks.nvim",
				---@param opts snacks.Config
				---@return snacks.Config
				opts = function(_, opts)
					return vim.tbl_deep_extend("force", opts or {}, {
						picker = {
							actions = require("trouble.sources.snacks").actions,
							win = {
								input = { keys = { ["<c-t>"] = { "trouble_open", mode = { "n", "i" } } } },
							},
						},
					})
				end,
			},
		},
	},
}
