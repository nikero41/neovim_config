---@class EditingKeymaps
---@field configure fun(self: EditingKeymaps, maps: Keymaps): nil
local EditingKeymaps = {}

function EditingKeymaps:configure(maps)
	maps:add("n", "n", {
		function()
			vim.cmd("normal! nzz")
			require("hlslens").start()
		end,
		desc = "Next result",
	})
	maps:add("n", "N", {
		function()
			vim.cmd("normal! Nzz")
			require("hlslens").start()
		end,
		desc = "Previous result",
	})
	maps:add("x", "<Leader>p", { '"_dP', desc = "Paste without coping" })
	maps:add("n", "<Leader>y", { '"+y', desc = "Yank to clipboard" })
	maps:add("x", "<Leader>y", { '"+y', desc = "Yank to clipboard" })
	maps:add("n", "<Leader>Y", { '"+Y', desc = "Yank rest of line to clipboard" })
	maps:add("x", "<Leader>Y", { '"+Y', desc = "Yank rest of line to clipboard" })
	maps:add("x", "<Leader>D", { '"_d', desc = "Cut" })
	maps:add("n", "<Leader>D", { '"_d', desc = "Cut" })
	maps:add("n", "<leader>C", {
		function()
			local bufs = vim.fn.getbufinfo({ buflisted = 1 })
			local bufnr = vim.api.nvim_get_current_buf()
			Snacks.bufdelete({ buf = bufnr })
			if not bufs[2] then Snacks.dashboard.open() end
		end,
		desc = "Close buffer",
	})
	maps:add("n", "<Leader>xn", { "<CMD>cnext<CR>", desc = "Next Quickfix" })
	maps:add("n", "<Leader>xp", { "<CMD>cprevious<CR>", desc = "Previous Quickfix" })
	maps:add("n", "<Leader>ltl", {
		function()
			vim.g.enable_golines = not vim.g.enable_golines
			vim.notify(
				"goliens " .. (vim.g.enable_golines and "enabled" or "disabled"),
				vim.log.levels.INFO,
				{ title = "LSP toggle" }
			)
		end,
		desc = "Toggle golines",
	})
end

return EditingKeymaps
