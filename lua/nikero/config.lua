---@class Config
---@field transparency boolean
---@field hide_code_lens_ft string[] Filetypes where code lens should be disabled
local Config = {
	transparency = false,
	hide_code_lens_ft = { "lua", "rust" },
}

return Config
