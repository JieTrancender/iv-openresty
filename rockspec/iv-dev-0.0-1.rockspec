package = "iv-dev"
version = "0.0-1"
source = {
    url = "git://github.com/JieTrancender/iv",
    branch = "master",
}

description = {
    summary = "i like, i love.",
    homepage = "https://keyboard-hero.com/iv",
    license = "Apache License 2.0",
    maintainer = "Mo Jie <jie-email@jie-trancender.org"
}

dependencies = {
    "lua-resty-template = 1.9",
    "lua-resty-etcd = 0.7",
    "lua-resty-ngxvar = 0.4",
    "lua-resty-jit-uuid = 0.0.7",
    "lua-resty-jwt = 0.2.0",
    "lua-resty-cookie = 0.1.0",
    "lua-resty-radixtree = 1.4",
    "jsonschema = 0.3",
    "lua-tinyyaml = 0.1",
}

build = {
    type = "make",
    build_variables = {
        CFLAGS="$(CFLAGS)",
        LIBFLAG="$(LIBFLAG)",
        LUA_LIBDIR="$(LUA_LIBDIR)",
        LUA_BINDIR="$(LUA_BINDIR)",
        LUA_INCDIR="$(LUA_INCDIR)",
        LUA="$(LUA)",
    },
    install_variables = {
        INST_PREFIX="$(PREFIX)",
        INST_BINDIR="$(BINDIR)",
        INST_LUADIR="$(LUADIR)",
        INST_CONFDIR="$(CONFIDR)",
    },
}