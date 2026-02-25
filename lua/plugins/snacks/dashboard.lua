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
						action = function() Snacks.dashboard.pick("files") end,
					},
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "w",
						desc = "Find Text",
						action = function() Snacks.dashboard.pick("live_grep") end,
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = function() Snacks.dashboard.pick("oldfiles") end,
					},
					{
						icon = " ",
						key = "g",
						desc = "Lazygit",
						action = function() Snacks.lazygit() end,
					},
					{ icon = " ", key = "p", desc = "Select project", action = vim.cmd.ProjectMgr },
					{
						icon = " ",
						key = "s",
						desc = "Restore Session",
						action = function() require("resession").load("Last Session") end,
					},
					{
						icon = "󰒲 ",
						key = "L",
						desc = "Lazy",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
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
					local in_git = Snacks.git.get_root() ~= nil
					local cmds = {
						{
							icon = " ",
							desc = "Browse Repo",
							key = "b",
							action = function() Snacks.gitbrowse() end,
						},
						{
							title = "Notifications",
							cmd = "gh notify -s -a -n5",
							action = function() vim.ui.open("https://github.com/notifications") end,
							key = "n",
							icon = " ",
							height = 5,
						},
						{
							title = "Open Issues",
							cmd = " if gh issue list -L 3; then gh issue list -L 3; fi",
							key = "i",
							action = function() vim.system({ "gh", "issue", "list", "--web" }, { detach = true }) end,
							icon = " ",
							height = 7,
						},
						{
							icon = " ",
							title = "Open PRs",
							cmd = "gh pr list -L 3",
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
							enabled = in_git,
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
