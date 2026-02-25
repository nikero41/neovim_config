---@type LazySpec
return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	branch = "harpoon2",
	keys = function()
		local harpoon = require("harpoon")

		return {
			{
				"<leader>hh",
				function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
				desc = "Toggle Harpoon",
			},
			{ "<leader>ha", function() harpoon:list():add() end, desc = "Add file to Harpoon" },
			{ "<C-p>", function() harpoon:list():prev() end, desc = "Previous Harpoon file" },
			{ "<C-n>", function() harpoon:list():next() end, desc = "Next Harpoon file" },
			{ "<M-z>", function() harpoon:list():select(1) end, desc = "Goto 1 of mark" },
			{ "<M-x>", function() harpoon:list():select(2) end, desc = "Goto 2 of mark" },
			{ "<M-c>", function() harpoon:list():select(3) end, desc = "Goto 3 of mark" },
			{ "<M-v>", function() harpoon:list():select(4) end, desc = "Goto 4 of mark" },
			{
				"<leader>hd",
				function()
					local harpoon_list = harpoon:list().items
					for index, item in pairs(harpoon_list) do
						if string.find(vim.api.nvim_buf_get_name(0), item.value) then
							table.remove(harpoon_list, index)
							break
						end
					end
				end,
				desc = "Remove current buffer from Harpoon",
			},
			{
				"<leader>fh",
				function()
					Snacks.input({ prompt = "Harpoon mark index: " }, function(input)
						local num = tonumber(input)
						if num then require("harpoon"):list():select(num) end
					end)
				end,
				desc = "Goto index of mark",
			},
		}
	end,
	---@type HarpoonPartialConfig
	opts = {
		settings = { save_on_toggle = true },
	},
	config = function(_, opts)
		local harpoon = require("harpoon")
		local extensions = require("harpoon.extensions")

		harpoon:setup(opts)
		harpoon:extend(extensions.builtins.navigate_with_number())
		harpoon:extend(extensions.builtins.highlight_current_file())

		-- Add keymaps for harpoon window
		harpoon:extend({
			UI_CREATE = function(cx)
				vim.keymap.set(
					"n",
					"<C-v>",
					function() harpoon.ui:select_menu_item({ vsplit = true }) end,
					{ buffer = cx.bufnr }
				)

				vim.keymap.set(
					"n",
					"<C-x>",
					function() harpoon.ui:select_menu_item({ split = true }) end,
					{ buffer = cx.bufnr }
				)
			end,
		})
	end,
}
