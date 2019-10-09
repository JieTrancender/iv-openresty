local fetch_local_conf = require("apisix.core.config_local").local_conf
local redis = require("resty.redis")
local clone_tab = require("table.clone")
local log = require("apisix.core.log")
local json = require("apisix.core.json")
local response = require("apisix.core.response")

local _M = {version = 0.1}

local function new()
    local local_conf, err = fetch_local_conf()
    if not local_conf then
        return nil, err
    end

    log.info("redis: ", json.delay_encode(local_conf.redis))
    local redis_conf = clone_tab(local_conf.redis)
    local redis_cli = redis:new()

    redis:set_timeouts(1000, 1000, 1000)

    local ok
    ok, err = redis_cli:connect(redis_conf.host, redis_conf.port)
    if not ok then
        return nil, err
    end

    return redis_cli
end

_M.new = new

function _M.get(key)
    local redis_cli, err = new()
    if not redis_cli then
        return nil, err
    end

    local res, err = redis_cli:get(key)
    log.info("get: ", err, " ", json.delay_encode(res))
    if not res then
        return nil, err
    end

    local ok
    ok, err = redis_cli:set_keepalive(10000, 100)
    if not ok then
        return nil, err
    end

    return res
end

return _M