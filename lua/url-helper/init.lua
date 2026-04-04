local Plugin = {}

local matcher = require("url-helper.core.matcher")

function Plugin.setup()
    local s, e, url = matcher.find_match_lpeg("acesse 'https://google.com/test?test1=1' e saiba mais")

    -- print(s, e, url)
end

return Plugin
