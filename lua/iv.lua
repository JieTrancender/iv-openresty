local require = require
local core = require("apisix.core")
local admin_init = require("iv.admin.init")
local get_var = require("resty.ngxvar").fetch
local router = require("iv.router")
local ngx = ngx
local get_method = ngx.req.get_method
local ngx_exit = ngx.exit

local _M = {
    version = 0.1
}

function _M.http_init()
    require("resty.core")

    local seed, err = core.utils.get_seed_from_urandom()
    if not seed then
        core.log.warn('failed to get seed from urandom: ', err)
        seed = ngx.now() * 1000 + ngx.worker.pid()
    end
    math.randomseed(seed)

    core.id.init()
end

function _M.http_init_worker()
    core.log.info("http_init_worker")
    -- router.http_init_worker()
    require("iv.admin.init").init_worker()
end

do
    local router

function _M.http_content()
    if not router then
        router = admin_init.get()
    end

    local ok = router:dispatch(get_var("uri"), {method = get_method()})
    core.log.info("http_content: ", get_var("uri"), get_method(), ok)
    if not ok then
        ngx_exit(404)
    end
end

end -- do

function _M.welcome()
    core.response.exit(200, "welcome...")
end

function _M.test()
    local radix = require("resty.radixtree")
    local rx = radix.new({
        {
            paths = {"/bb*", "/aa"},
            hosts = {"*.bar.com", "foo.com"},
            methods = {"GET", "POST", "PUT"},
            remote_addrs = {"127.0.0.1", "192.168.0.0/16"},
            vars = {
                {"arg_name", "==", "json"},
                {"arg_weight", ">", 10},
            },
            filter_fun = function(vars)
                return vars["arg_name"] == "json"
            end,
            metadata = "metadata /bb",
        }
    })

    ngx.say(rx:match("/aa", {host = "foo.com",
                             method = "GET",
                             remote_addr = "127.0.0.1",
                             vars = ngx.var}))
end

return _M
