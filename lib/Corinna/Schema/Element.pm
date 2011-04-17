use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);


#===================================================
package Corinna::Schema::Element;

use Corinna::Schema::Object;

our @ISA = qw(Corinna::Schema::Object);

Corinna::Schema::Element->mk_accessors(qw(baseClasses minOccurs maxOccurs targetNamespace));


sub isSingleton {
	my $self = shift;
	
	my $maxOccurs = $self->maxOccurs();
	
	return 1 unless ($maxOccurs);
	return 0 if ($maxOccurs eq 'unbounded');
	return 1 if ($maxOccurs == 1);
	return 0;			
}

1;

__END__

=head1 NAME

B<Corinna::Schema::Group> - Class that represents the META information about a W3C schema B<group>.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much about this module to actually use L<Corinna>.  It is 
documented here for completeness and for L<Corinna> developers. Do not count on the interface of this module. It may change in 
any of the subsequent releases. You have been warned. 

=head1 ISA

This class descends from L<Corinna::Schema::Object>.


=head1 SYNOPSIS
  
  my $g = Corinna::Schema::Group->new();
  
  $g->setFields(name => 'personal', scope=> 'global', nameIsAutoGenerated=>0);

  $g->elements(['lastName', 'firstName', 'title', 'dateOfBirth']);
  
  print $g->name();	# prints 'personal'.
  print $g->scope();# prints 'global'.
  

=head1 DESCRIPTION

B<Corinna::Schema::Group> is a data-oriented object class that reprsents a W3C B<group>. It is
parsed from the W3C schema and is used a building block for the produced B<schema model>. Objects of this 
class contain META information about the W3C schema B<group> that they represent. 

Like other schema object classes, this is a data-oriented object class, meaning it doesn't have many methods other 
than a constructor and various accessors. 

=head1 METHODS

=head2 CONSTRUCTORS
 
=head4 new() 

  $class->new(%fields)

B<CONSTRUCTOR>, overriden. 

The new() constructor method instantiates a new object. It is inheritable. 
  
Any -named- fields that are passed as parameters are initialized to those values within
the newly created object. 

In its overriden form, what this method does is as follows:

=over

=item * sets the I<contentType> field to 'I<group>';

=item * creates the B<elements> array-ref field if not passed already as a parameter;

=item * creates the B<elementInfo> hash-ref field if not passed already as a parameter;

=back

.

=head2 ACCESSORS

=head3 Inherited accessors

Several accessors are inherited by this class from its ancestor L<Corinna::Schema::Object>. 
Please see L<Corinna::Schema::Object> for a documentation of those.

=head3 Accessors defined here

=head4 baseClasses()

  my $bases = $object->baseClasses();	# GET
  $object->baseClasses($bases);  	    # SET

The base classes of this element class, when it is generated by L<Corinna>. This value is
computed at schema model I<resolution> time by L<Corinna::Schema::Model/resolve()>.

=head4 maxOccurs()

  my $maxo = $object->maxOccurs();	# GET
  $object->maxOccurs($maxo);  	    # SET

This is a W3C property.

The maximum allowed occurences of this child element. This can be any non-negative integer or the string
'I<unbounded>'. 

=head4 minOccurs()

  my $mino = $object->minOccurs();	# GET
  $object->minOccurs($mino);  	    # SET

This is a W3C property.

The minimum allowed occurences of this child element. This can be any non-negative integer. 
When it is zero (0), this means the occurence of this child element is optional.

.

=head2 OTHER METHODS

=head4 isSingleton()

This returns a boolean value. When TRUE(1), this means that the child element is a singleton, meaning
the B<maxOccurs> property is either undefined or it is exactly 1. 

.

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

See also L<Corinna>, L<Corinna::ComplexType>, L<Corinna::SimpleType>

If you are curious about the implementation, see L<Corinna::Schema::Parser>,
L<Corinna::Schema::Model>, L<Corinna::Generator>.

If you really want to dig in, see L<Corinna::Schema::Attribute>, L<Corinna::Schema::AttributeGroup>,
L<Corinna::Schema::ComplexType>, L<Corinna::Schema::Element>, L<Corinna::Schema::Group>,
L<Corinna::Schema::List>, L<Corinna::Schema::SimpleType>, L<Corinna::Schema::Type>, 
L<Corinna::Schema::Object>

=cut
