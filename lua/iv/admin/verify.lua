local core = require("apisix.core")
local http = require("resty.http")
local table_concat = table.concat

local appid = "wxa020bb825fc38cc6"
local secret = "9f2eae8aeb724991a45a8064c5e9a152"

local _M = {
	version = 0.1
}

function _M.post( id, conf )
	core.log.info("verify ", id, " ", conf.code, core.json.delay_encode(conf))

	local httpc = http:new()
	local urlTbl = {
		"https://api.weixin.qq.com/sns/jscode2session?appid=",
		appid,
		"&secret=",
		secret,
		"&js_code=",
		conf.code,
		"&grant_type=authorization_code",
	}
	core.log.info("url: ", table_concat(urlTbl))
	local resp, err = httpc:request_uri(table_concat(urlTbl),
	{
		method = "GET"
	})

	core.log.info("err", err, core.json.delay_encode(resp))

	return 200, resp
end

return _M
