#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Mojolicious::Plugin::CouchAuth' ) || print "Bail out!\n";
}

diag( "Testing Mojolicious::Plugin::CouchAuth $Mojolicious::Plugin::CouchAuth::VERSION, Perl $], $^X" );
