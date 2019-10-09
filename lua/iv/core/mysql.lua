local fetch_local_conf = require("apisix.core.config_local").local_conf
local mysql = require("resty.mysql")
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

    log.info("mysql: ", json.delay_encode(local_conf.mysql))
    local mysql_conf = clone_tab(local_conf.mysql)
    local mysql_cli
    mysql_cli, err = mysql:new()
    if not mysql_cli then
        return nil, err
    end

    mysql_cli:set_timeout(1000)

    local ok, errcode, sqlstate
    ok, err, errcode, sqlstate = mysql_cli:connect(mysql_conf)
    if not ok then
        return nil, err
    end

    return mysql_cli
end

_M.new = new

function _M.query(sql)
    local mysql_cli, err = new()
    if not mysql_cli then
        return nil, err
    end

    -- response.exit(200, "hahaha")

    local res, err, errcode, sqlstate = mysql_cli:query(sql)
    log.info("query: ", sql, " ", json.delay_encode(res), " ", err, " ", errcode, " ", sqlstate)
    if not res then
        return nil, err
    end

    local ok
    ok, err = mysql_cli:set_keepalive(10000, 100)
    if not ok then
        log.error("mysql#query failed to set keepalive: ", err)
    end

    return res
end

return _M