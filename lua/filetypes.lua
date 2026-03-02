---@class Filetypes
---@field javascript string[]
---@field setup fun(self: Filetypes)
local Filetypes = {
	javascript = {
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"jsx",
	},
}

function Filetypes:setup()
	vim.filetype.add({
		extension = {
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

	-- close some filetypes with <q>
	vim.api.nvim_create_autocmd("FileType", {
		-- TODO: group = augroup("close_with_q"),
		pattern = {
			"PlenaryTestPopup",
			"checkhealth",
			"dbout",
			"gitsigns-blame",
			"grug-far",
			"help",
			"lspinfo",
			"neotest-output",
			"neotest-output-panel",
			"neotest-summary",
			"notify",
			"qf",
			"spectre_panel",
			"startuptime",
			"tsplayground",
		},
		callback = function(event)
			vim.bo[event.buf].buflisted = false
			vim.schedule(function()
				vim.keymap.set("n", "q", function()
					vim.cmd("close")
					pcall(vim.api.nvim_buf_delete, event.buf, { force = true }) -- TODO: use snack?
				end, {
					buffer = event.buf,
					silent = true,
					desc = "Quit buffer",
				})
			end)
		end,
	})
end

return Filetypes
