vim.g.mapleader = " "
vim.g.maplocalleader = ","

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

-- Indentation
vim.o.tabstop = 2
-- vim.o.showfulltag = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- Splits
vim.o.splitright = true
vim.o.splitbelow = true

vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

vim.o.undofile = true

-- Performance
vim.o.updatetime = 250
vim.o.timeoutlen = 400

-- Disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.g.loaded_perl_provider = 0
