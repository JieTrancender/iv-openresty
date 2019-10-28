local fetch_local_conf = require("apisix.core.config_local").local_conf
local core = require("apisix.core")
local table_concat = table.concat
local prefix

local _M = {
    version = 0.1
}

local function check_conf( id, conf, need_id )
    if not conf then
        return nil, {error_msg = "missing username and password"}
    end

    if not conf.username then
        return nil, {error_msg = "missing username"}
    end

    if not conf.email then
        return nil, {error_msg = "missing email"}
    end

    if not conf.password then
        return nil, {error_msg = "missing password"}
    end

    id = id or conf.id
    if need_id and not id then
        return nil, {error_msg = "missing user id"}
    end

    if not need_id and id then
        return nil, {error_msg = "wrong user id, do not need it"}
    end

    if need_id and conf.id and tostring(conf.id) ~= tostring(id) then
        return nil, {error_msg = "wrong user id"}
    end

    core.log.info("schema: ", core.json.delay_encode(core.schema.user))
    core.log.info("conf: ", core.json.delay_encode(conf))
    local ok, err = core.schema.check(core.schema.user, conf)
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

    if not prefix then
        -- 默认通过邮件注册
        local local_conf, err = fetch_local_conf()
        if not local_conf then
            return 500, {error_msg = err}
        end
        prefix = local_conf.redis.prefix
    end

    local emailKeyTbl = {prefix, ":email2id:", conf.email}
    local emailKey = table_concat(emailKeyTbl)
    local res, err = core.redis.mget(emailKey)
    if not res then
        core.log.error("failed to post user[", emailKey, conf.email, err)
        return 500, {error_msg = err}
    end

    if res[1] ~= ngx.null then
        return 400, {error_msg = "this email has been registed"}
    end

    core.log.info("new user:", conf.username, " ", conf.email, " ", conf.password)
    local userCount = prefix..":userCount"
    res, err = core.redis.incr(userCount)
    if not res then
        return 500, {error_msg = err}
    end

    local userId = res
    res, err = core.redis.mset(emailKey, userId)
    if not res then
        return 500, {error_msg = err}
    end

    local userHash = table_concat({prefix, ":user:", userId})
    res, err = core.redis.hmset(userHash, "username", conf.username, "email", conf.email, "password", conf.password)
    if not res then
        return 500, {error_msg = err}
    end

    return 200, {userId = userId, username = conf.username, email = conf.email}
end

-- function _M.post(id, conf)
--     local id, err = check_conf(id, conf, false)
--     if not id then
--         return 400, err
--     end

--     local key = "/services"
--     local res, err = core.etcd.push(key, conf)
--     if not res then
--         core.log.error("failed to post service[", key, "]: ", err)
--         return 500, {error_msg = err}
--     end

--     return res.status, res.body
-- end

-- function _M.put(id, conf)
--     local id, err = check_conf(id, conf, true)
--     if not id then
--         return 400, err
--     end

--     local key = "/services/" .. id
--     core.log.info("key: ", key)
--     local res, err = core.etcd.set(key, conf)
--     if not res then
--         core.log.error("failed to put service[", key, "]: ", err)
--         return 500, {error_msg = err}
--     end

--     return res.status, res.body
-- end


-- function _M.get(id)
--     local key = "/services"
--     if id then
--         key = key .. "/" .. id
--     end

--     local res, err = core.etcd.get(key)
--     if not res then
--         core.log.error("failed to get service[", key, "]: ", err)
--         return 500, {error_msg = err}
--     end

--     return res.status, res.body
-- end





return _M
