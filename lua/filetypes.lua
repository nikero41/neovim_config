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
	prettier_config = {
		".prettierrc",
		".prettierrc.cjs",
		".prettierrc.cts",
		".prettierrc.js",
		".prettierrc.json",
		".prettierrc.json5",
		".prettierrc.mjs",
		".prettierrc.mts",
		".prettierrc.toml",
		".prettierrc.ts",
		".prettierrc.yaml",
		".prettierrc.yml",
		"prettier.config.cjs",
		"prettier.config.js",
		"prettier.config.mjs",
		"prettier.config.mts",
		"prettier.config.ts",
	},
	eslint_config = {
		-- ESLint <=8 (Deprecated)
		".eslintignore",
		".eslintrc",
		".eslintrc.cjs",
		".eslintrc.js",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
		-- ESLint >=9
		"eslint.config.cjs",
		"eslint.config.cts",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.mts",
		"eslint.config.ts",
	},
}

function Filetypes:setup()
	vim.filetype.add({
		extension = {
			podspec = "ruby",
			tmux = "tmux",
			gitconfig = "gitconfig",
			pcss = "postcss",
			postcss = "postcss",
			hl = "hyprlang",
			just = "just",
			pg = "sql",
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
			["docker-compose.ya?ml"] = "yaml.docker-compose",
			[".*/hypr/.*.conf"] = "hyprlang",
			["hypr.*.conf"] = "hyprlang",
			[".?[jJ]ustfile"] = "just", -- TODO: should be a better pattern
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
