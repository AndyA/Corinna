package Corinna::Schema::AttributeGroup;
use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);

#=================================================

use Corinna::Schema::Object;

our @ISA = qw(Corinna::Schema::Object);

Corinna::Schema::AttributeGroup->mk_accessors(qw(attributes attribute_info));

sub new {
    my $class = shift;
    my $self  = {@_};

    unless ( $self->{attributes} ) {
        $self->{attributes} = [];
    }
    unless ( $self->{attribute_info} ) {
        $self->{attribute_info} = {};
    }
    unless ( $self->{contentType} ) {
        $self->{contentType} = "attributeGroup";
    }

    return bless $self, $class;
}

1;

__END__

=head1 NAME

B<Corinna::Schema::AttributeGroup> - Class that represents the META information about a W3C schema B<attribute group>.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much
about this module to actually use L<Corinna>.  It is documented here for
completeness and for L<Corinna> developers. Do not count on the interface of
this module. It may change in any of the subsequent releases. You have been
warned.

=head1 ISA

This class descends from L<Corinna::Schema::Object>.


=head1 SYNOPSIS

  my $ag = Corinna::Schema::AttributeGroup->new();

  $ag->set_fields(name => 'personal', scope=> 'global', name_is_auto_generated=>0);

  $ag->attributes(['lastName', 'firstName', 'title', 'dateOfBirth']);

  print $ag->name();	# prints 'personal'.
  print $ag->scope();	# prints 'global'.


=head1 DESCRIPTION

B<Corinna::Schema::AttributeGroup> is a data-oriented object class that reprsents a W3C B<attribute group>. It is
parsed from the W3C schema and is used a building block for the produced B<schema model>. Objects of this
class contain META information about the W3C schema B<attribute group> that they represent.

Like other schema object classes, this is a data-oriented object class, meaning it doesn't have many methods other
than a constructor and various accessors.

=head1 METHODS

=head2 CONSTRUCTORS

=head4 new()

  $class->new(%fields)

B<CONSTRUCTOR>, overriden.

The new() constructor method instantiates a new B<Corinna::Schema::Object> object. It is inheritable, and indeed inherited,
by the decsendant classes.

Any -named- fields that are passed as parameters are initialized to those values within
the newly created object.

In its overriden form, what this method does is as follows:

=over

=item * sets the I<contentType> field to 'I<attributeGroup>';

=item * creates the B<attributes> array-ref field if not passed already as a parameter;

=item * creates the B<attribute_info> hash-ref field if not passed already as a parameter;

=back

.

=head2 ACCESSORS

=head3 Inherited accessors

Several accessors are inherited by this class from its ancestor L<Corinna::Schema::Object>.
Please see L<Corinna::Schema::Object> for a documentation of those.

=head3 Accessors defined here

=head4 attributes()

  my $attribs = $object->attributes();  # GET
  $object->attributes($attribs);        # SET

A reference to an array containing the names of the attributes that this B<attribute group> has.

=head4 attribute_info()

  my $ai = $object->attribute_info();  # GET
  $object->attribute_info($ai);        # SET

A reference to a hash whose keys are the names of the attributes, and whose values are
objects of type L<Corinna::Schema::Attribute>, that give meta information about those attributes.


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

