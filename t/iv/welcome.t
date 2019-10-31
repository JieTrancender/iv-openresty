use t::IV 'no_plan';

repeat_each(1);
run_tests();

__DATA__

=== TEST 1: iv welcome
--- config
    location /foo {
        content_by_lua_block {
            local iv = require("iv")
            iv.welcome()
        }
    }
--- request
    GET /foo
--- response_body
welcome...
