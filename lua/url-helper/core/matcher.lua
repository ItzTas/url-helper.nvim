local M = {}

local lpeg = vim.lpeg
local Cp = lpeg.Cp
local C = lpeg.C
local P = lpeg.P
local V = lpeg.V

local pattern_module = require("url-helper.core.patterns")
local pattern = pattern_module.pattern

local function anywhere(p)
    return P({ p + 1 * V(1) })
end

---@param text string
---@return number|nil, number|nil, string|nil
function M.find_match_lpeg(text)
    local find_pattern = anywhere(Cp() * pattern * Cp())
    local start_pos, url, end_pos = find_pattern:match(text)

    return start_pos, end_pos, url
end

return M
