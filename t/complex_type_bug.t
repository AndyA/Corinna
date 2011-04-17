
use Test::Most 'no_plan';
use Corinna;

use File::Path;

rmtree( ['./test/out/lib'] );

my $pastor = Corinna->new();
lives_ok {
    $pastor->generate(
        mode  => 'offline',
        style => 'multiple',
        schema =>
          ['./test/source/bugs/schema/complex_type_from_simple_type.xsd'],
        class_prefix => "Corinna::Test",
        destination  => './test/out/lib/',
        verbose      => 0
    );
} 'Complex types which extend simple types should survive';

lives_ok {
    $pastor->generate(
        mode  => 'eval',
        style => 'multiple',
        schema =>
          ['./test/source/bugs/schema/complex_type_from_simple_type.xsd'],
        class_prefix => "Corinna::Test",
        destination  => './test/out/lib/',
        verbose      => 0
    );
} 'Complex types which extend simple types should survive';
