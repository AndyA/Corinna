
use Test::More tests => 3;

use File::Path;
use_ok('Corinna');

rmtree( ['./test/out/lib'] );

my $pastor = Corinna->new();
$pastor->generate(
    mode         => 'offline',
    style        => 'multiple',
    schema       => ['./test/source/country/schema/country_schema1.xsd'],
    class_prefix => "Corinna::Test",
    destination  => './test/out/lib/',
    verbose      => 0
);

eval("use lib qw (./test/out/lib/);\nuse Corinna::Test;");

if ($@) {
    print STDERR "$@\n";
}

ok( !$@, "Use generated module" );

#	print STDERR "\nTest OVER baby!\n";
ok(1);    # survived everything

1;

