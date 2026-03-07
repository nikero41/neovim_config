---@alias CommandGroup { name: string, commands: Command[] }
---@alias Command { [1]: string, [2]: string | fun() }

---@class CommandPalette
---@field groups CommandGroup[]
---@field select_command fun(self: CommandPalette, commands: Command[])
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
						vim.ui.input(
							{ prompt = "PR number: " },
							function(input) Snacks.picker.gh_diff({ pr = assert(tonumber(input), "Invalid PR number") }) end
						)
					end,
				},
				{
					"Open PR/Issue in browser",
					function()
						vim.ui.select({ "PR", "Issue" }, {}, function(input)
							vim.ui.input({ prompt = input .. " number: " }, function(number)
								if input == "PR" then
									Snacks.picker.gh_diff({ pr = assert(tonumber(number), "Invalid PR number") })
								else
									Snacks.picker.gh_diff({ issue = number })
								end
							end)
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

function CommandPalette:select_command(commands)
	vim.ui.select(
		commands,
		{ prompt = "Select command:", format_item = function(item) return item[1] end },
		function(command)
			if command and type(command[2]) == "function" then
				command[2]()
			elseif command and type(command[2]) == "string" then
				vim.cmd(command[2])
			end
		end
	)
end

function CommandPalette:show()
	vim.ui.select(
		self.groups,
		{ prompt = "Select category:", format_item = function(item) return item.name end },
		function(group)
			if not group then return end
			self:select_command(group.commands)
		end
	)
end

return CommandPalette
