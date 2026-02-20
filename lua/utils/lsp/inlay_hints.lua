local M = {}

function M:truncate(hints)
	local max_len = 30 -- Set your desired character limit

	for _, hint in ipairs(hints) do
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
end

return M
