package Corinna::Builtin::SimpleType;
use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);

#======================================================================

use Corinna::SimpleType;

our @ISA = qw(Corinna::SimpleType);

1;

__END__

=head1 NAME

B<Corinna::Builtin::SimpleType> - Ancestor of all classes that correspond to W3C B<builtin> simple types.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much about this module to actually use L<Corinna>.  It is 
documented here for completeness and for L<Corinna> developers. Do not count on the interface of this module. It may change in 
any of the subsequent releases. You have been warned. 

=head1 ISA

This class descends from L<Corinna::SimpleType>. 

=head1 DESCRIPTION

At this time, this class is just used for grouping the B<builtin> classes. 
No methods are defined at this level.

=head1 METHODS

=head2 INHERITED METHODS

This class inherits many methods from its ancestors. Please see L<Corinna::SimpleType> for 
more methods. 

=head1 BUGS & CAVEATS

There no known bugs at this time, but this doesn't mean there are aren't any. 
Note that, although some testing was done prior to releasing the module, this should still be considered alpha code. 
So use it at your own risk.

Note that there may be other bugs or limitations that the author is not aware of.

=head1 AUTHOR

Ayhan Ulusoy <dev(at)ulusoy(dot)name>


=head1 COPYRIGHT

  Copyright (C) 2006-2007 Ayhan Ulusoy. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=head1 SEE ALSO

See also L<Corinna>, L<Corinna::ComplexType>, L<Corinna::SimpleType>, L<Corinna::Builtin>

If you are curious about the implementation, see L<Corinna::Schema::Parser>,
L<Corinna::Schema::Model>, L<Corinna::Generator>.
 
=cut
