local M = {}

local lpeg = vim.lpeg
local Cp = lpeg.Cp
local C = lpeg.C

local pattern_module = require("url-helper.core.patterns")
local lpeg_pattern = pattern_module.lpeg_pattern

---@param text string
---@return number|nil, number|nil, string|nil
function M.find_match_lpeg(text)
    local start_pos, url, end_pos = lpeg.match(Cp() * C(lpeg_pattern) * Cp(), text)

    -- if not start_pos then
    --     return nil, nil, nil
    -- end

    return start_pos, end_pos - 1, url
end

return M
