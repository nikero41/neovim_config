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
			[".?[jJ]ustfile"] = "just",
		},
	})

	local group = vim.api.nvim_create_augroup("close-with-q", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		desc = "Close with <q>",
		group = group,
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
		callback = function(args)
			vim.bo[args.buf].buflisted = false

			if not vim.g.q_close_windows then vim.g.q_close_windows = {} end
			if vim.g.q_close_windows[args.buf] then return end

			vim.g.q_close_windows[args.buf] = true

			for _, map in ipairs(vim.api.nvim_buf_get_keymap(args.buf, "n")) do
				if map.lhs == "q" then return end
			end

			vim.schedule(function()
				Snacks.keymap.set("n", "q", function()
					Snacks.bufdelete.delete({ buf = args.buf, force = true })
					vim.cmd.close()
				end, { buf = args.buf, desc = "Quit buffer" })
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		desc = "Clean up q_close_windows cache",
		group = group,
		callback = function(args)
			if vim.g.q_close_windows then vim.g.q_close_windows[args.buf] = nil end
		end,
	})
end

return Filetypes
