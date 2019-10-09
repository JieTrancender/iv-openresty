local require = require
local core = require("apisix.core")
local route = require("resty.radixtree")
local get_method = ngx.req.get_method
local str_lower = string.lower
local ngx = ngx

local resources = {
    notes = require("iv.admin.notes"),
}

local _M = {
    version = 0.1
}
local router

local function run()
    local uri_segs = core.utils.split_uri(ngx.var.uri)
    core.log.info("uri: ", core.json.delay_encode(uri_segs))

    local seg_res, seg_id = uri_segs[3], uri_segs[4]
    local seg_sub_path = core.table.concat(uri_segs, "/", 6)
    core.log.info("seg_res: ", seg_res, seg_id)
    local resource = resources[seg_res]
    if not resource then
        core.response.exit(404)
    end

    local method = str_lower(get_method())
    if not resource[method] then
        core.response.exit(404)
    end

    ngx.req.read_body()
    local req_body = ngx.req.get_body_data()
    if req_body then
        local data, err = core.json.decode(req_body)
        if not data then
            core.log.error("invalid request body: ", req_body, " err: ", err)
            core.response.exit(400, {error_msg = "invalid request body",
                                     req_body = req_body})
        end

        req_body = data
    end

    core.log.info("~~~~~~~~~", seg_res, " ", get_method(), " ", seg_id, " ", core.json.encode(req_body or {}))
    local code, data = resource[method](seg_id, req_body, seg_sub_path)
    if code then
        core.response.exit(code, data)
    end
end

local uri_route = {
    {
        paths = [[/iv/*]],
        methods = {"GET", "PUT", "POST", "DELETE", "PATCH"},
        handler = run,
    }
}

function _M.init_worker()
    core.log.info("admin/init#init_worker ", core.json.delay_encode(uri_route))
    router = route.new(uri_route)
end

function _M.get()
    return router
end

return _M
