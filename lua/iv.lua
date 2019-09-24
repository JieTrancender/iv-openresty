local require = require
local core = require("apisix.core")


local _M = {
    version = 0.1
}

function _M.welcome()
    core.response.exit(200, "welcome...")
end

return _M