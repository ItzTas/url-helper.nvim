local M = {}

local lpeg = vim.lpeg
local R = lpeg.R
local S = lpeg.S
local P = lpeg.P
local Cg = lpeg.Cg

M.lpeg_locale = {}
lpeg.locale(M.l)

local l = M.lpeg_locale

local url_char = R("az", "AZ") + R("09") + S("-._~:/?#[]@!$&'()*+,;=%")
local sep1 = P("://")
local port = P(":") * l.digit ^ 1

local patterns_table = {
    http = {
        pattern =
            Cg(
                (P("http") * sep1 ^ -1) * P("://") * (port ^ -1),
                "http"
            ),
        activated = true,
    },
    ftp = {
        pattern =
            Cg(
                P("ftp") * sep1 * (url_char ^ 1),
                "ftp"
            ),
        activated = true,
    },
    file = {
        pattern =
            Cg(
                P("file") * sep1 * (url_char ^ 0),
                "file"
            ),
        activated = true,
    },
    ssh = {
        pattern =
            Cg(P("ssh") * sep1 * (url_char ^ 1)),
        activated = true,
    },
}

local pattern

for _, v in pairs(patterns_table) do
    if not v.activated then
        goto continue
    end

    if not pattern then
        pattern = v.pattern
        goto continue
    end

    pattern = pattern + v.pattern

    ::continue::
end

M.patterns_table = patterns_table

M.pattern = pattern

return M
