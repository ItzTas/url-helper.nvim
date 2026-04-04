local matcher = require("url-helper.core.matcher")

local GroupName = "UrlHighlight"
local namespace = vim.api.nvim_create_namespace(GroupName)

vim.api.nvim_set_hl(0, GroupName, { link = "Underlined" })
