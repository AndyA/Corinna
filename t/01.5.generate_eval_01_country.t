
use Test::More tests => 2;

use_ok('Corinna');

my $pastor = Corinna->new();

$pastor->generate(
    mode         => 'eval',
    schema       => ['./test/source/country/schema/country_schema1.xsd'],
    class_prefix => "Corinna::Test",
    destination  => './test/out/lib/',
    verbose      => 0
);

#	print STDERR "\nTest OVER baby!\n";
ok(1);    # survived everything

1;

