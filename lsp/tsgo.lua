---@type vim.lsp.Config | { settings?: lsp.ts_ls }
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
	handlers = {
		["textDocument/inlayHint"] = function(error, result, ctx)
			local max_len = 30 -- Set your desired character limit

			if result ~= nil then
				for _, hint in ipairs(result) do
					local label = hint.label

					-- Handle string label
					if type(label) == "string" and vim.fn.strchars(label) > max_len then
						hint.label = vim.fn.strcharpart(label, 0, math.max(max_len - 1, 0)) .. "…"
					-- Handle label parts (array of InlayHintLabelPart)
					elseif type(label) == "table" then
						local total_len = 0
						local truncated = {}

						for _, part in ipairs(label) do
							local part_text = part.value or ""
							local part_len = vim.fn.strchars(part_text)

							if total_len + part_len > max_len then
								local remaining = math.max(max_len - total_len - 1, 0)
								part.value = vim.fn.strcharpart(part_text, 0, remaining) .. "…"
								part.value = part_text:sub(1, remaining) .. "…"
								table.insert(truncated, part)
								break
							end

							total_len = total_len + part_len
							table.insert(truncated, part)
						end

						hint.label = truncated
					end
				end
			end

			vim.lsp.inlay_hint.on_inlayhint(error, result, ctx)
		end,
	},
}
