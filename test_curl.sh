#!/bin/bash

# curl -ig 'localhost:8080/iv/welcome'

# curl -ig 'localhost:8080/iv/notes?page=2&per_page=12'

# curl -ig 'localhost:8080/iv/notes' -X POST -d '
# {
#     "content": "i like, i love by curl."
# }'

# curl -ig 'https://keyboard-hero.com/apisix/admin/upstreams/6' -X PUT -d '
# {
# 	"desc": "keyboard-hero.com:8090",
# 	"type": "roundrobin",
# 	"nodes": {
# 		"keyboard-hero.com:8090": 1
# 	}
# }'

# curl -ig 'https://keyboard-hero.com/apisix/admin/upstreams/7' -X PUT -d '
# {
# 	"desc": "jie-trancender.org:8081",
# 	"type": "roundrobin",
# 	"nodes": {
# 		"jie-trancender.org:8081": 1
# 	}
# }'

curl -ig 'localhost:8080/iv/verify' -X POST -d '
{
	"code": "FDFNASFLSAFASFFASF"
}'

