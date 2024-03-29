local core = require("apisix.core")
local http = require("resty.http")
local jwt = require("resty.jwt")
local table_concat = table.concat

local appid = "wxa020bb825fc38cc6"
local secret = "9f2eae8aeb724991a45a8064c5e9a152"
local requestHost = "https://api.weixin.qq.com"
local requestPath = "/sns/jscode2session"
local session

local _M = {
	version = 0.1
}

function _M.post( id, conf )
	core.log.info("verify ", id, " ", core.json.delay_encode(conf))

	local httpc = http:new()
	-- local urlTbl = {
	-- 	"https://api.weixin.qq.com/sns/jscode2session?appid=",
	-- 	appid,
	-- 	"&secret=",
	-- 	secret,
	-- 	"&js_code=",
	-- 	conf.code,
	-- 	"&grant_type=authorization_code",
	-- }
	-- core.log.info("url: ", table_concat(urlTbl))
	-- local err
	-- session, err = httpc:ssl_handshake(session, requestHost, false)
	-- if not session then
	-- 	core.log.error("verfiy ssl_handshake wrong: ", err)
	-- 	return 503, {error = err}
	-- end

	local res, err = httpc:request_uri(requestHost,
	{
		path = requestPath,
		method = "GET",
		query = 
		{
			appid = appid,
			secret = secret,
			js_code = conf.code,
			grant_type = "authorization_code"
		},
		ssl_verify = false,
	})

	if not res then
		core.log.error("verify wrong: ", err)
		return 503, {error = err}
	end

	core.log.info("verify:", res.status, res.body)

	return res.status, res.body
end

function _M.get()
	local headers = ngx.req.get_headers()
	core.log.info("get: ", core.json.delay_encode(headers))
	local jwt_token = headers["Authorization"]
	local jwt_obj = jwt:verify("lua-resty-jwt", jwt_token)

	core.log.info("jwt_token: ", jwt_token)
	core.log.info("payload: ", core.json.delay_encode(jwt_obj.payload))
	-- core.log.info("key: ", jwt_obj.payload.key)


	return 200, jwt_obj
end

return _M
