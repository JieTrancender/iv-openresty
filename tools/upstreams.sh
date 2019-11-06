. setPath.sh

curl http://${HOST}:${PORT}/apisix/admin/upstreams/8090 -X PUT -d '
{
	"id": 8090,
	"desc": "iv:8090",
    "type": "roundrobin",
    "nodes": {
    	"keyboard-hero.com:8090": 1,
    	"keyboard-man.site:8090": 1
    }
}'
