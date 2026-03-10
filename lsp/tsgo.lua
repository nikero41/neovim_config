---@type vim.lsp.Config
return {
	settings = {
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = true },
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = true },
			},
		},
	},
	cmd = function(dispatchers, config)
		local cmd = "tsgo"
		local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/tsgo"
		if local_cmd and vim.fn.executable(local_cmd) == 1 then cmd = local_cmd end
		return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
	end,
	filetypes = require("filetypes").javascript,
	root_dir = function(bufnr, on_dir)
		local root_markers =
			{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })

		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
		local project_root = vim.fs.root(bufnr, root_markers)
		if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then return end
		if deno_root and (not project_root or #deno_root >= #project_root) then return end
		on_dir(project_root or vim.fn.getcwd())
	end,
	handlers = {
		["textDocument/inlayHint"] = function(error, result, ctx)
			local max_len = 30 -- Set your desired character limit

			for _, hint in ipairs(result) do
				local label = hint.label

				-- Handle string label
				if type(label) == "string" and #label > max_len then
					hint.label = label:sub(1, max_len) .. "…"
				-- Handle label parts (array of InlayHintLabelPart)
				elseif type(label) == "table" then
					local total_len = 0
					local truncated = {}

					for _, part in ipairs(label) do
						local part_text = part.value or ""

						if total_len + #part_text > max_len then
							local remaining = max_len - total_len
							part.value = part_text:sub(1, remaining) .. "…"
							table.insert(truncated, part)
							break
						end

						total_len = total_len + #part_text
						table.insert(truncated, part)
					end

					hint.label = truncated
				end
			end

			vim.lsp.inlay_hint.on_inlayhint(error, result, ctx)
		end,
	},
}
