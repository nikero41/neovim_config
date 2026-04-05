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
			vim.fn.sign_define(
				"BqfSign",
				{ text = " " .. require("icons").status.selected, texthl = "BqfSign" }
			)
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>ud", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then vim.notify(err, vim.log.levels.ERROR) end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
		---@module "trouble"
		---@type trouble.Config
		opts = {
			focus = true,
			modes = {
				lsp = { win = { position = "right" } },
			},
			preview = { scratch = true },
		},
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
			{
				"nvim-neotest/neotest",
				---@type neotest.Config
				---@diagnostic disable-next-line: missing-fields
				opts = {
					consumers = {
						trouble = function(client)
							client.listeners.results = function(adapter_id, results, partial)
								if partial then return end
								local tree = assert(client:get_position(nil, { adapter = adapter_id }))

								local should_close = vim.tbl_count(
									vim
										.iter(results)
										:enumerate()
										:filter(
											function(pos_id, result)
												return result.status ~= "failed" and tree:get_key(pos_id)
											end
										)
										:totable()
								) == 0

								vim.schedule(function()
									local trouble = require("trouble")
									if trouble.is_open() then
										trouble.refresh()
										if should_close then trouble.close() end
									end
								end)
							end
							return {}
						end,
					},
				},
			},
		},
	},
}
