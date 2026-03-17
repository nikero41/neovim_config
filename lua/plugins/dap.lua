---@type LazySpec
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
			{
				"rcarriga/cmp-dap",
				config = function()
					local blink_avail, blink = pcall(require, "blink.cmp")
					if blink_avail then
						for _, dap_ft in ipairs({ "dap-repl", "dapui_watches", "dapui_hover" }) do
							blink.add_filetype_source(dap_ft, "dap")
						end
					end
				end,
				specs = {
					{
						"Saghen/blink.cmp",
						dependencies = {
							{ "Saghen/blink.compat", version = "*", opts = {} },
						},
						opts = {
							sources = {
								providers = {
									dap = {
										name = "dap",
										module = "blink.compat.source",
										score_offset = 100,
									},
								},
							},
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>dB",
				function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function() require("dap").toggle_breakpoint() end,
				desc = "Toggle Breakpoint",
			},
			{ "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
			-- {
			-- 	"<leader>da",
			-- 	function() require("dap").continue({ before = get_args }) end,
			-- 	desc = "Run with Args",
			-- },
			{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
			{ "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>dj", function() require("dap").down() end, desc = "Down" },
			{ "<leader>dk", function() require("dap").up() end, desc = "Up" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
			{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
			{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>ds", function() require("dap").session() end, desc = "Session" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		},

		config = function()
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			-- for name, sign in pairs(LazyVim.config.icons.dap) do
			-- 	sign = type(sign) == "table" and sign or { sign }
			-- 	vim.fn.sign_define("Dap" .. name, {
			-- 		text = sign[1],
			-- 		texthl = sign[2] or "DiagnosticInfo",
			-- 		linehl = sign[3],
			-- 		numhl = sign[3],
			-- 	})
			-- end

			-- setup dap config by VSCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			---@diagnostic disable-next-line: duplicate-set-field
			vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>de",
				function()
					vim.ui.input({ prompt = "Expression: " }, function(expr)
						if expr then require("dapui").eval(expr, { enter = true }) end
					end)
				end,
				desc = "Evaluate Input",
			},
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debugger UI" },
			{ "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" },
			{ "<leader>de", function() require("dapui").eval() end, desc = "Evaluate Input", mode = "v" },
		},
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
		end,
	},
}
