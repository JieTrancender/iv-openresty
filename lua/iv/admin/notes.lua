local core = require("apisix.core")

local _M = {
    version = 0.1
}

local function check_conf(id, conf, need_id)
    if not conf then
        return nil, {error_msg = "missing configurations"}
    end

    id = id or conf.id
    if need_id and not id then
        return nil, {error_msg = "missing note id"}
    end

    if not need_id and id then
        return nil, {error_msg = "wrong note id, do not need it"}
    end

    if need_id and conf.id and tostring(conf.id) ~= tostring(id) then
        return nil, {error_msg = "wrong note id"}
    end

    core.log.info("schema: ", core.json.delay_encode(core.schema.note))
    core.log.info("conf: ", core.json.delay_encode(conf))
    local ok, err = core.schema.check(core.schema.note, conf)
    if not ok then
        return nil, {error_msg = "invalid configuration: " .. err}
    end

    return need_id and id or true
end

function _M.get(id)
    core.log.info("get: ", id)
    -- id = id or 1
    -- local res, err = core.redis.get(id)
    -- if not res then
    --     core.log.error("failed to get note[", key, "]: ", err)
    --     return 500, {error_msg = err}
    -- end

    -- return 200, {data = res}

    local sql
    if not id then
        sql = "select * from notes;"
    else
        sql = "select * from notes where id = " .. id .. ";"
    end

    local res, err = core.mysql.query(sql)
    if not res then
        core.log.error("failed to get note[", key, "]: ", err)
        return 500, {error_msg = err}
    end

    core.log.info("res: ", core.json.delay_encode(res))
    return 200, res

    -- local key = "/notes"
    -- if id then
    --     key = key .. "/" .. id
    -- end

    -- local res, err = core.etcd.get(key)
    -- if not res then
    --     core.log.error("failed to get note[", key, "]: ", err)
    --     return 500, {error_msg = err}
    -- end

    -- return res.status, res.body
end

function _M.put(id, conf)
    core.log.info("notes/post", id, core.json.delay_encode(conf))
    local id, err = check_conf(id, conf, true)
    if not id then
        return 400, err
    end

    local key = "/notes/" .. id
    local res, err = core.etcd.set(key, conf)
    if not res then
        core.log.error("failed to put note[", key, "]: ", err)
        return 500, {error_msg = err}
    end

    return res.status, res.body
end

function _M.post(id, conf)
    local id, err = check_conf(id, conf, false)
    if not id then
        return 400, err
    end

    local sql = "insert into notes(content) values(\"" .. conf.content .. "\");"
    local res, err = core.mysql.query(sql)
    if not res then
        core.log.error("failed to get note[", key, "]: ", err)
        return 500, {error_msg = err}
    end

    core.log.info("res: ", core.json.delay_encode(res))
    return 200, res

    -- local key = "/notes"
    -- local res, err = core.etcd.push("/notes", conf)
    -- if not res then
    --     core.log.error("failed to post note[", key, "]: ", err)
    --     return 500, {error_msg = err}
    -- end

    -- return res.status, {data = res.body}
end

return _M