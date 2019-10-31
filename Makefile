INST_PREFIX ?= /usr
INST_LIBDIR ?= $(INST_PREFIX)/lib64/lua/5.1
INST_LUADIR ?= $(INST_PREFIX)/share/lua/5.1
INST_BINDIR ?= /usr/bin
INSTALL ?= install
UNAME ?= $(shell uname)
OR_EXEC ?= $(shell which openresty)
LUA_JIT_DIR ?= $(shell ${OR_EXEC} -V 2>&1 | grep prefix | grep -Eo 'prefix=(.*?)/nginx' | grep -Eo '/.*/')luajit
LUAROCKS_VER ?= $(shell luarocks --version | grep -Eo "luarocks [0-9]+.")
TEST_CMD ?= bin/busted $(BUSTED_ARGS)

# DEV_ROCKS = "busted" "luacheck"

.PHONY: dev init run reload stop clean test

# dependencies:
# 	@for rock in $(DEV_ROCKS) ; do \
# 		if luarocks list --porcelain $$rock | grep -q "installed" ; then \
# 			echo $$rock already installed, skipping ; \
# 		else \
# 			echo $$rock not found, installing via luarocks... ; \
# 			luarocks install $$rock ; \
# 		fi \
# 	done;

help:
	@echo Makefile rules:
	@echo
	@grep -E '^### [-A-Za-z0-9_]+:' Makefile | sed 's/###/   /'


### dev:          create a development environment
dev:
ifeq ($(UNAME),Darwin)
	luarocks install --lua-dir=$(LUA_JIT_DIR) rockspec/iv-dev-0.0-1.rockspec --only-deps
else ifneq ($(LUAROCKS_VER),'luarocks 3.')
	luarocks install rockspec/iv-dev-0.0-1.rockspec --only-deps
else
	luarocks install --lua-dir=/usr/local/openresty/luajit rockspec/iv-dev-0.0-1.rockspec --only-deps
endif


### init:          initialize the runtime environment
init:
	./bin/iv init


### run:           start the iv server
run:
	mkdir -p logs
	$(OR_EXEC) -p $$PWD -c $$PWD/conf/nginx.conf


### reload:        reload the iv server
reload:
	$(OR_EXEC) -p $$PWD -c $$PWD/conf/nginx.conf -s reload


### stop:          stop the iv server
stop:
	$(OR_EXEC) -p $$PWD -c $$PWD/conf/nginx.conf -s stop


### clean:         remove generated files
clean:
	rm -rf logs/


### test:          run the test case
test:
	TEST_NGINX_LOG_LEVEL=info \
	prove -I../test-nginx/lib -r -s t/
