local M = {}

local lpeg = vim.lpeg
local R = lpeg.R
local S = lpeg.S
local P = lpeg.P
local Cg = lpeg.Cg
local C = lpeg.C
local Cp = lpeg.Cp

M.lpeg_locale = {}
lpeg.locale(M.l)

local sep1 = P("://")
local port = P(":") * (R("09") ^ 1)

local alnum = R("az", "AZ", "09")

local domain = Cg(
    ((alnum + ("09") + S("._-")) ^ 1 * P("@")) ^ -1 *
    (alnum + ("09") + S("-.")) ^ 1,
    "domain"
)
local path_char = ((alnum) + S("-._~!$&'()*+,;=:@/"))
local path = P("/") * (path_char ^ 1) * (P("/") ^ -1)

local qchar = alnum + S("-._~!$&'()*+,;=:@/?")

local function params()
    local pair = (qchar ^ 1) * P("=") * (qchar ^ 0)

    local query_body = pair * ((P("&") * pair) ^ 0)

    local query = P("?") * (query_body ^ -1)

    local fragment = (P("#") * qchar ^ 0)

    local url_params = (query * (fragment ^ -1))
    return qchar
end


local patterns_table = {
    http = {
        pattern =
            Cg(
                (P("http") * (P("s") ^ -1)) * sep1 * domain * (port ^ -1) * (path ^ -1) * (params() ^ 0),
                "http"
            ),
        activated = true,
    },
    ftp = {
        pattern =
            Cg(
                P("ftp") * sep1 * (path ^ -1),
                "ftp"
            ),
        activated = true,
    },
    file = {
        pattern =
            Cg(
                P("file") * sep1 * (path ^ -1),
                "file"
            ),
        activated = true,
    },
    ssh = {
        pattern =
            Cg(
                P("ssh") * sep1 * (path ^ -1),
                "ssh"
            ),
        activated = true,
    },
}

local function wrap_pattern(pattern, name)
    local wrap
    pattern = Cp() * C(pattern) * Cp()
    local wraps = {
        (
            pattern * S(" \n")
        ),
        (
            P("'") * pattern * P("'")
        ),
        (
            P('"') * pattern * P('"')
        ),
        (
            P("`") * pattern * P("`")
        ),
        (
            P("(") * pattern * P(")")
        ),
    }

    for _, v in pairs(wraps) do
        if not wrap then
            wrap = v
        end
        wrap = wrap + v
    end

    return wrap + pattern
end


for k, v in pairs(patterns_table) do
    if not v.activated then
        goto continue
    end

    if not M.pattern then
        M.pattern = wrap_pattern(v.pattern, k)
        goto continue
    end

    M.pattern = M.pattern + wrap_pattern(v.pattern, k)

    ::continue::
end

M.patterns_table = patterns_table

return M
