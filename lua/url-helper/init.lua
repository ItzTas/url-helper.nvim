local Plugin = {}

function Plugin.setup()
    local matcher = require("url-helper.core.matcher")

    local s, e, url = matcher.find_match_lpeg("acesse https://google.com agora")
    print(s, e, url)
end

return Plugin
