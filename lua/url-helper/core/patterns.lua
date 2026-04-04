local M = {}

local lpeg = vim.lpeg
local C = lpeg.C
local R = lpeg.R
local S = lpeg.S
local P = lpeg.P

local url_char = R("az", "AZ") + R("09") + S("-._~:/?#[]@!$&'()*+,;=%")
local http_header = P("http") + P("https")
local scheme = C(http_header) * P("://") * C(url_char ^ 1)

patterns = {
    http = {
        scheme = P("http") + P("https"),
    },
}

M.lpeg_patterns = {
    http = {
        pattern = nil,
        activated = true,
    },
}

return M
