---@alias KeymapsPackage "astronvim"|"packages"

---@class DisableKeymaps
---@field configure fun(self: DisableKeymaps, maps: Keymaps, options: table<KeymapsPackage, boolean>): nil
local DisableKeymaps = {
	astronvim = {
		{ mode = "n", lhs = "<Leader>fa" }, -- auto-save.nvim
		{ mode = "n", lhs = "<Leader>fh" }, -- find help
		{ mode = "n", lhs = "<Leader>uu" }, -- undotree.vim
		{ mode = "n", lhs = "<Leader>ft" }, -- todo-comments.nvim
		{ mode = "n", lhs = "<Leader>fT" }, -- todo-comments.nvim
		{ mode = "n", lhs = "<Leader>ud" }, -- neo-tree-diagnostics.nvim
		{ mode = "n", lhs = "<Leader>fm" }, -- find man
		{ mode = "n", lhs = "<Leader>u>" }, -- toggle fold columns
		{ mode = "n", lhs = "<Leader>uy" }, -- toggle syntax highlighting
		{ mode = "n", lhs = "<Leader>up" }, -- toggle paste mode
		{ mode = "n", lhs = "<Leader>un" }, -- change line numbering
		{ mode = "n", lhs = "<Leader>ug" }, -- toggle git signs column
		{ mode = "n", lhs = "<Leader>uC" }, -- toggle autocompletion
		{ mode = "n", lhs = "<Leader>uc" }, -- toggle autocompletion
		{ mode = "n", lhs = "<Leader>ui" }, -- change indent setting
		{ mode = "n", lhs = "<Leader>ut" }, -- toggle tabline
		{ mode = "n", lhs = "<Leader>ul" }, -- toggle statusline
		{ mode = "n", lhs = "<Leader>uS" }, -- toggle conceal
		{ mode = "n", lhs = "<Leader>C" }, -- force close buffer
		{ mode = "n", lhs = "<Leader>c" }, -- close buffer
		{ mode = "n", lhs = "<Leader>h" }, -- home screen
		{ mode = "n", lhs = "<Leader>tl" }, -- duplicate lazygit
		{ mode = "n", lhs = "<Leader>lG" }, -- search workspace symbol
		{ mode = "n", lhs = "<Leader>lR" }, -- search references
		{ mode = { "n", "o", "x" }, lhs = "<Leader>w" }, -- nvim-spider
		{ mode = { "n", "o", "x" }, lhs = "<Leader>e" }, -- nvim-spider
		{ mode = "n", lhs = "<Leader>ur" }, -- trouble
		{ mode = "n", lhs = "<Leader>tt" }, -- btm
		{ mode = "n", lhs = "<Leader>fs" }, -- snacks smart
		{ mode = "n", lhs = "<Leader>fl" }, -- snacks find line
		{ mode = "n", lhs = "<Leader>us" }, -- toggle spellcheck
		{ mode = "n", lhs = "<Leader>ub" }, -- toggle background
		{ mode = "n", lhs = "<Leader>uR" }, -- snacks find line
		{ mode = "n", lhs = "<Leader>uv" }, -- toggle virtual text
		{ mode = "n", lhs = "<Leader>uV" }, -- toggle virtual lines
		{ mode = "n", lhs = "<Leader>uz" }, -- toggle color highlight
		{ mode = "n", lhs = "<Leader>u|" }, -- toggle indent lines
	},
	packages = {
		{ mode = "n", lhs = "<Leader>pa" },
		{ mode = "n", lhs = "<Leader>pi" },
		{ mode = "n", lhs = "<Leader>pm" },
		{ mode = "n", lhs = "<Leader>pM" },
		{ mode = "n", lhs = "<Leader>ps" },
		{ mode = "n", lhs = "<Leader>pS" },
		{ mode = "n", lhs = "<Leader>pu" },
		{ mode = "n", lhs = "<Leader>pU" },
	},
}

function DisableKeymaps:configure(maps, options)
	if options.astronvim then
		for _, keymap in ipairs(self.astronvim) do
			maps:add(keymap.mode, keymap.lhs, false)
		end
	end

	if options.packages then
		for _, keymap in ipairs(self.packages) do
			maps:add(keymap.mode, keymap.lhs, false)
		end
	end
end

return DisableKeymaps
