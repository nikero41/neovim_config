---@type LazySpec
return {
	"folke/snacks.nvim",
	keys = {
		{
			"<leader>gg",
			function() Snacks.lazygit() end,
			desc = "Open Lazygit",
		},
		{
			"<leader>gi",
			function() Snacks.picker.gh_issue() end,
			desc = "GitHub Issues (open)",
		},
		{
			"<leader>gI",
			function() Snacks.picker.gh_issue({ state = "all" }) end,
			desc = "GitHub Issues (all)",
		},
		{
			"<leader>gP",
			function() Snacks.picker.gh_pr() end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>gL",
			function() Snacks.git.blame_line() end,
			desc = "View full Git blame",
		},
		{ "<Leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git branches" },
		{
			"<Leader>gc",
			function() require("snacks").picker.git_log() end,
			desc = "Git commits (repository)",
		},
		{
			"<Leader>gC",
			function() require("snacks").picker.git_log({ current_file = true, follow = true }) end,
			desc = "Git commits (current file)",
		},
		{ "<Leader>gt", function() require("snacks").picker.git_status() end, desc = "Git status" },
		{ "<Leader>gT", function() require("snacks").picker.git_stash() end, desc = "Git stash" },
	},
}
