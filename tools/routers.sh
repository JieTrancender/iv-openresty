. setPath.sh

# curl http://${HOST}:${PORT}/apisix/admin/routes/1 -X PUT -d '
# {
#     "methods": ["GET"],
#     "uri": "/iv/notes",
#     "plugins": {
#         "jwt-auth": {}
#     },
#     "upstream": {
#         "type": "roundrobin",
#         "nodes": {
#             "192.168.3.130:8080": 1
#         }
#     }
# }'

# curl http://${HOST}:${PORT}/apisix/admin/routes/2 -X PUT -d '
# {
#     "methods": ["GET"],
#     "uri": "/iv/verify",
#     "plugins": {
#         "jwt-auth": {}
#     },
#     "upstream": {
#         "type": "roundrobin",
#         "nodes": {
#             "192.168.3.130:8080": 1
#         }
#     }
# }'

curl http://${HOST}:${PORT}/apisix/admin/routes/3 -X PUT -d '
{
    "methods": ["GET", "POST", "DELETE", "PUT"],
    "uri": "/iv/*",
    "plugins": {
    },
    "upstream": {
        "type": "roundrobin",
        "nodes": {
            "192.168.3.130:8080": 1
        }
    }
}'