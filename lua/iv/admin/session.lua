local core = require("apisix.core")

local _M = {
    version = 0.1
}

local function check_conf( id, conf, need_id )
    if not conf then
        return nil, {error_msg = "missing username and passworld"}
    end

    if not conf.username then
        return nil, {error_msg = "missing username"}
    end

    if not conf.passworld then
        return nil, {error_msg = "missing passworld"}
    end

    id = id or conf.id
    if need_id and not id then
        return nil, {error_msg = "missing session id"}
    end

    if not need_id and id then
        return nil, {error_msg = "wrong session id, do not need it"}
    end

    if need_id and conf.id and tostring(conf.id) ~= tostring(id) then
        return nil, {error_msg = "wrong session id"}
    end

    core.log.info("schema: ", core.json.delay_encode(core.schema.session))
    core.log.info("conf: ", core.json.delay_encode(conf))
    local ok, err = core.schema.check(core.schema.session, conf)
    if not ok then
        return nil, {error_msg = "invalid arguments: ", err}
    end

    if need_id and not tonumber(id) then
        return nil, {error_msg = "wrong type of user id"}
    end

    return need_id and id or true
end

function _M.post( id, conf )
    local id, err = check_conf(id, conf, false)
    if not id then
        return 400, err
    end

    
    local res, err = core.redis.mget(emailKey)    
end

return _M
