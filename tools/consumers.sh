. setPath.sh

# curl http://${HOST}:${PORT}/apisix/admin/consumers -X PUT -d '
# {
#     "username": "kbm",
#     "plugins": {
#         "jwt-auth": {
#             "key": "mojie",
#             "secret": "keyboard-hero.com"
#         }
#     }
# }'

# curl http://${HOST}:${PORT}/apisix/admin/consumers -X PUT -d '
# {
#     "username": "kbh",
#     "plugins": {
#         "jwt-auth": {
#             "key": "kbh",
#             "secret": "keyboard-hero.com",
#             "userId": 1
#         }
#     }
# }'

curl http://${HOST}:${PORT}/apisix/admin/consumers -X PUT -d '
{
    "username": "kbh",
    "plugins": {
        "jwt-auth": {
            "key": "kbhh",
            "secret": "keyboard-hero.com",
            "userId": 1
        }
    }
}'

