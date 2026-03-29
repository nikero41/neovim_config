---@alias CommandGroup { name: string, commands: Command[] }
---@alias Command { [1]: string, [2]: string | fun() }

---@class CommandPalette
---@field groups CommandGroup[]
---@field select_command fun(self: CommandPalette, commands: Command[], on_back: fun())
---@field show fun(self: CommandPalette)
local CommandPalette = {
	groups = {
		{
			name = "LSP",
			commands = {
				{ "Restart tsserver", ":VtsExec restart_tsserver" },
				{ "Restart eslint_d", ":! eslint_d restart" },
				{ "Restart prettierd", ":!prettierd restart" },
				{ "Restart lua-ls", ":LspRestart lua-ls" },
			},
		},
		{
			name = "File",
			commands = {
				{ "Inspect types", ":InspectTwoslashQueries" },
				{ "Toggle inline folds", ":InlineFoldToggle" },
				{ "Search and Replace", ":SearchAndReplace" },
				{ "Toggle env variables", "CloakToggle" },
			},
		},
		{
			name = "Git",
			commands = {
				{ "View on GitHub", function() Snacks.gitbrowse() end },
				{
					"View PR Diff",
					function()
						vim.ui.input({ prompt = "PR number: " }, function(input)
							if not input or input == "" then return end
							local pr = tonumber(input)
							if not pr then
								vim.notify("Invalid PR number", vim.log.levels.WARN)
								return
							end
							Snacks.picker.gh_diff({ pr = pr })
						end)
					end,
				},
			},
		},
		{
			name = "Vim",
			commands = {
				{ "Open Lazy", function() require("lazy").home() end },
				{ "Open Mason", ":Mason" },
				{ "Zen mode", function() Snacks.zen() end },
				{ "Check health", ":checkhealth" },
				{
					"Change colorscheme",
					function() Snacks.picker.colorschemes() end,
				},
				{ "Commands", function() Snacks.picker.commands() end },
			},
		},
	},
}

function CommandPalette:select_command(commands, on_back)
	local function go_back(picker)
		picker:close()
		if on_back then vim.schedule(on_back) end
	end

	local snacks_opts = {
		layout = { preset = "vscode" },
		focus = "list",
		actions = {
			back_or_delete = function(picker)
				if picker.input:get() ~= "" then return "<BS>" end
				go_back(picker)
			end,
			back = go_back,
		},
		win = {
			input = {
				keys = {
					["<BS>"] = { "back_or_delete", mode = "i", expr = true },
					["<C-h>"] = { "back_or_delete", mode = "i", expr = true },
				},
			},
			list = {
				keys = {
					["<BS>"] = "back",
					["<C-h>"] = "back",
				},
			},
		},
	}

	vim.ui.select(commands, {
		prompt = "Select command:",
		snacks = snacks_opts,
		format_item = function(item) return item[1] end,
	}, function(command)
		if not command then return end

		if type(command[2]) == "function" then
			command[2]()
		elseif type(command[2]) == "string" then
			vim.cmd(command[2])
		end
	end)
end

function CommandPalette:show()
	vim.ui.select(self.groups, {
		prompt = "Select category:",
		snacks = { layout = { preset = "vscode" }, focus = "list" },
		format_item = function(item) return item.name end,
	}, function(group)
		if not group then return end
		self:select_command(group.commands, function() self:show() end)
	end)
end

return CommandPalette
