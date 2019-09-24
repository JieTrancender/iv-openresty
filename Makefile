OR_EXEC ?= $(shell which openresty)


.PHONY: help
help:
	@echo Makefile rules:
	@echo
	@grep -E '^### [-A-Za-z0-9_]+:' Makefile | sed 's/###/   /'


### init:          initialize the runtime environment
.PHONY: init
init:
	./bin/iv init


### run:           start the iv server
.PHONY: run
run:
	mkdir -p logs
	$(OR_EXEC) -p $$PWD -c $$PWD/conf/nginx.conf


### reload:        reload the iv server
.PHONY: reload
reload:
	$(OR_EXEC) -p $$PWD -c $$PWD/conf/nginx.conf -s reload


### stop:          stop the iv server
.PHONY: stop
stop:
	$(OR_EXEC) -p $$PWD -c $$PWD/conf/nginx.conf -s stop


### clean:         remove generated files
.PHONY: clean
clean:
	rm -rf logs/


### test:          run the test case
.PHONY: help
test:
	prove -I test-nginx/lib -r t