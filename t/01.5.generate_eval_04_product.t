
use Test::More tests=>2;

use_ok ('Corinna');


my $pastor = Corinna->new();
	
$pastor->generate(	mode =>'eval',
					schema=>['./test/source/mathworks/schema/product.xsd'], 
					class_prefix=>"Corinna::Test::MathWorks::",
					destination=>'./test/out/lib/', 					
					verbose =>0
				);
				
				

#	print STDERR "\nTest OVER baby!\n";			
ok(1);	# survived everything
  

1;

