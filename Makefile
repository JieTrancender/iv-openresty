OR_EXEC ?= $(shell which openresty)
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


### dev:          initialize the runtime environment
# dev: dependencies

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
# test:
# 	@$(TEST_CMD) spec/welcome_spec.lua
# 	prove -I test-nginx/lib -r t
# 	resty -I lua test/busted_runner.lua
# 	resty -Ilua -Ilualib -Iconfig spec/welcome_spec.lua