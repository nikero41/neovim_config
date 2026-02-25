require("options")
require("keymaps")


require("init_new")
require("highlights")

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = vim.o.winborder, source = "if_many" },
	underline = true,
	signs = {},
	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Test shows up underneath the line, with virtual lines
	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = { float = true },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
