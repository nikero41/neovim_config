---@type LazySpec
return {
	"rebelot/heirline.nvim",
	dependencies = {
		"abeldekat/harpoonline",
		---@type HarpoonLineConfig
		---@diagnostic disable: missing-fields
		opts = { icon = "" },
	},
	opts = function(_, opts)
		local status = require("astroui.status")

		opts.statusline = {
			hl = { fg = "fg", bg = "bg" },
			status.component.mode(),
			status.component.git_branch(),
			status.component.file_info({
				filetype = {},
				filename = false,
				file_modified = false,
			}),
			status.component.builder({
				provider = function()
					local line = require("harpoonline").format()
					return status.utils.stylize(line, { padding = { left = 1, right = 1 } })
				end,
				hl = function()
					if require("harpoonline").is_buffer_harpooned() then
						return { bg = "command", fg = "bg" }
					end
				end,
			}),
			status.component.git_diff(),
			status.component.fill(),
			status.component.cmd_info(),
			status.component.fill(),
			status.component.diagnostics({
				padding = { right = 0 },
				surround = { separator = "none" },
			}),
			-- LSP
			status.component.builder(status.utils.setup_providers(
				{
					lsp_client_names = {
						str = " ",
						update = { "LspAttach", "LspDetach", "BufEnter" },
						icon = { kind = "ActiveLSP", padding = { right = 0 } },
					},
					hl = status.hl.get_attributes("lsp"),
					surround = {
						separator = "right",
						color = "lsp_bg",
						condition = status.condition.lsp_attached,
					},
					on_click = {
						name = "heirline_lsp",
						callback = function()
							vim.defer_fn(function() vim.cmd.LspInfo() end, 100)
						end,
					},
				},
				{ "lsp_client_names" },
				function(p_opts)
					return {
						flexible = 1,
						status.utils.build_provider(p_opts, status.provider.str(p_opts)),
					}
				end
			)),
			status.component.treesitter(),
			status.component.nav(),
		}

		opts.statuscolumn = nil

		return opts
	end,
}
