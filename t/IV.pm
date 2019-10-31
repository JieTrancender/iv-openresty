package t::IV;

use lib 'lib';

use Test::Nginx::Socket::Lua::Stream -Base;

repeat_each(2);
log_level('info');
no_long_string();
no_shuffle();

my $pwd = `pwd`;
chomp $pwd;

sub read_file($) {
    my $infile = shift;
    open my $in, $infile
        or die "cannot open $infile for reading: $!";
    my $cert = do { local $/; <$in> };
    close $in;
    $cert;
}

my $yaml_config = read_file("conf/config.yaml");
$yaml_config =~ s/node_listen: 8080/node_listen: 1984/;

add_block_preprocessor(sub {
    my ($block) = @_;

    my $init_by_lua_block = $block->init_by_lua_block // <<_EOC_;
    require "resty.core"
    
    iv = require("iv")
    iv.http_init()
_EOC_

    my $http_config = $block->http_config // '';
    $http_config .= <<_EOC_;
    lua_package_path '$pwd/lua/?.lua;;';

    init_by_lua_block {
        $init_by_lua_block
    }

    $http_config
_EOC_

    $block->set_value("http_config", $http_config);

    my $user_yaml_config = $block->yaml_config // $yaml_config;
    my $user_files = $block->user_files;
    $user_files .= <<_EOC_;
>>> ../conf/config.yaml
$user_yaml_config
_EOC_

    $block->set_value("user_files", $user_files);

    $block;
});

1;
