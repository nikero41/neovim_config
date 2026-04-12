vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.colorscheme = require("colorscheme")

-- Editing
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.laststatus = 3
vim.o.wrap = false
vim.o.winborder = "rounded"
vim.o.confirm = true
vim.g.have_nerd_font = true
vim.o.autoread = true
vim.o.cmdheight = 0
vim.opt.linebreak = true
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = {
	eob = " ",
	vert = "|",
	horiz = "_",
	foldopen = require("icons").folds.open,
	foldclose = require("icons").folds.closed,
	foldsep = " ",
	foldinner = " ",
}

-- Indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.copyindent = true
vim.o.preserveindent = true
vim.opt.breakindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.tabclose = "uselast"

-- Folding
vim.o.foldenable = true
vim.o.foldcolumn = "1"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldtext = ""

-- Performance
vim.o.updatetime = 250
vim.o.timeoutlen = 400
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- Checkhealth
vim.g.loaded_perl_provider = 0

vim.opt.diffopt = vim.list_extend(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" }) -- enable linematch diff algorithm

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = require("icons").diagnostics.error,
			[vim.diagnostic.severity.HINT] = require("icons").diagnostics.hint,
			[vim.diagnostic.severity.WARN] = require("icons").diagnostics.warn,
			[vim.diagnostic.severity.INFO] = require("icons").diagnostics.info,
		},
	},
	jump = {
		on_jump = function(diagnostic, buffer)
			if not diagnostic then return end
			vim.diagnostic.open_float({ bufnr = buffer, scope = "cursor", focus = false })
		end,
	},
	float = {
		border = vim.o.winborder,
		source = true,
		header = "",
		prefix = function(diagnostic)
			local icon = {
				[vim.diagnostic.severity.ERROR] = require("icons").diagnostics.error,
				[vim.diagnostic.severity.HINT] = require("icons").diagnostics.hint,
				[vim.diagnostic.severity.WARN] = require("icons").diagnostics.warn,
				[vim.diagnostic.severity.INFO] = require("icons").diagnostics.info,
			}

			local highlight = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticError",
				[vim.diagnostic.severity.HINT] = "DiagnosticHint",
				[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
				[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			}

			return icon[diagnostic.severity] .. "  ", highlight[diagnostic.severity]
		end,
	},
})

require("vim._core.ui2").enable({ enable = true })
