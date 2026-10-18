---@type LazySpec
return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>ua", function() Snacks.dashboard.open() end, desc = "Toggle home screen" },
	},
	---@type snacks.Config
	opts = {
		dashboard = {
			preset = {
				keys = {
					{
						icon = " ",
						key = "f",
						desc = "Find File",
						action = function() require("fff").find_files() end,
					},
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "w",
						desc = "Find Text",
						action = function() require("fff").live_grep() end,
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = function() Snacks.dashboard.pick("oldfiles") end,
					},
					{ icon = " ", key = "p", desc = "Select project", action = ":Project snacks" },
					{
						icon = " ",
						key = "s",
						desc = "Restore Session",
						action = function() require("persistence").load({ last = true }) end,
					},
					{
						icon = "󰒲 ",
						key = "l",
						desc = "Lazy",
						action = function() vim.cmd.Lazy() end,
						enabled = package.loaded.lazy ~= nil,
					},
					{
						icon = "󰒲 ",
						key = "m",
						desc = "Mason",
						action = function() vim.cmd.Mason() end,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},

				header = [[
 ███    ██ ██ ██  ██ ██████ ██████   ██████
 ████   ██ ██ ██ ██  ██     ██   ██ ██    ██
 ██ ██  ██ ██ ████   ████   ██████  ██    ██
 ██  ██ ██ ██ ██ ██  ██     ██   ██ ██    ██
 ██   ████ ██ ██  ██ ██████ ██   ██  ██████]],
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{
					icon = " ",
					title = "Recent Files",
					section = "recent_files",
					indent = 2,
					padding = 1,
				},
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				function()
					local cmds = {
						{
							icon = " ",
							desc = "Open Repo",
							key = "R",
							action = function() Snacks.gitbrowse() end,
						},
						{
							title = "Notifications",
							cmd = "gh notify -s -a -n5 || true",
							action = function() vim.ui.open("https://github.com/notifications") end,
							key = "n",
							icon = " ",
							height = 5,
						},
						{
							title = "Open Issues",
							cmd = "gh issue list -L 3 || true",
							key = "i",
							action = function() vim.system({ "gh", "issue", "list", "--web" }, { detach = true }) end,
							icon = " ",
							height = 7,
						},
						{
							icon = " ",
							title = "Open PRs",
							cmd = "gh pr list -L 3 || true",
							key = "P",
							action = function() vim.system({ "gh", "pr", "list", "--web" }, { detach = true }) end,
							height = 7,
						},
						{
							icon = " ",
							title = "Git Status",
							cmd = "git diff --stat",
							height = 10,
						},
					}

					return vim.tbl_map(function(cmd)
						local has_cmd = not not cmd.cmd
						return vim.tbl_extend("force", {
							pane = 2,
							section = has_cmd and "terminal" or nil,
							enabled = Snacks.git.get_root() ~= nil,
							padding = 1,
							ttl = has_cmd and 5 * 60 or nil,
							indent = has_cmd and 3 or nil,
						}, cmd)
					end, cmds)
				end,
				{ section = "startup" },
			},
		},
	},
}
