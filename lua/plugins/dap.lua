---@type LazySpec
return {
	{
		"rcarriga/nvim-dap-ui",
		keys = {
			{
				"<leader>dS",
				function() require("dapui").open({ reset = true }) end,
				desc = "Resize debugger buffers",
			},
		},
		opts = {
			floating = { border = require("utils.constants").border_type },
		},
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.*",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					---@diagnostic disable-next-line: missing-fields
					require("dap-vscode-js").setup({
						debugger_path = vim.uv.fs_realpath(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
						adapters = {
							"pwa-node",
							"pwa-chrome",
							"pwa-msedge",
							"pwa-extensionHost",
							"node-terminal",
						},
					})
				end,
			},
		},
		config = function()
			local dap = require("dap")

			for _, language in ipairs(require("utils.constants").filetype.javascript) do
				dap.configurations[language] = {
					-- TODO: unimplemented
					{
						name = "Next.js: debug server-side",
						type = "node-terminal",
						request = "launch",
						command = "yarn dev",
					},
					-- TODO: unimplemented
					{
						name = "Next.js: debug full stack",
						type = "node-terminal",
						request = "launch",
						command = "npm run dev",
						serverReadyAction = {
							pattern = "- Local:.+(https?://.+)",
							uriFormat = "%s",
							action = "debugWithChrome",
						},
					},
					-- TODO: unimplemented
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					-- TODO: unimplemented
					-- Debug nodejs processes (make sure to add --inspect when you run the process)
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					-- TODO: unimplemented
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch Test Program (pwa-node with vitest)",
						cwd = "${workspaceFolder}",
						program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
						args = { "run", "${file}" },
						autoAttachChildProcesses = true,
						smartStep = true,
						skipFiles = { "<node_internals>/**", "node_modules/**" },
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch & Debug Chrome",
						url = function()
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input({
									prompt = "Enter URL: ",
									default = "http://localhost:3000",
								}, function(url)
									if url == nil or url == "" then
										return
									else
										coroutine.resume(co, url)
									end
								end)
							end)
						end,
						webRoot = "${workspaceFolder}",
						skipFiles = { "<node_internals>/**", "node_modules/**" },
						sourceMaps = true,
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
					},
					-- TODO: unimplemented
					{
						name = "React native",
						type = "node2",
						request = "attach",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
						port = 35000,
					},
					-- TODO: unimplemented
					-- Divider for the launch.json derived configs
					{
						name = "----- ↓ launch.json configs ↓ -----",
						type = "",
						request = "launch",
					},
				}
			end
		end,
	},
}
