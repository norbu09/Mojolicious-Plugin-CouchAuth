use inc::Module::Install;

name     'Mojolicious-Plugin-CouchAuth';
all_from 'lib/Mojolicious/Plugin/CouchAuth.pm';
author   q{Lenz Gschwendtner <norbu09@cpan.org>};
license  'perl';

build_requires 'Test::More';

requires 'Store::CouchDB';
requires 'Digest::SHA';

auto_install;

WriteAll;

