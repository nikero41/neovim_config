vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Editing
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.opt.winborder = "rounded"
vim.opt.confirm = true

-- Indentation
vim.opt.tabstop = 2
-- vim.opt.showfulltag = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.undofile = true

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

vim.g.loaded_perl_provider = 0
