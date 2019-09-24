use Test::Nginx::Socket 'no_plan';


run_tests();

__DATA__

=== TEST 1: welcome
--- config
    location /t {
        content_by_lua_block {
            ngx.say("welcome...")
        }
    }
--- request
GET /t
--- response_body
welcome...
--- no_error_log
[error]
