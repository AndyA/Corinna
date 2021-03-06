package Corinna::Schema::Object;
use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);

#================================================================
use base qw (Class::Accessor);

Corinna::Schema::Object->mk_accessors(
    qw(class definition documentation is_redefinable meta_class name name_is_auto_generated ref ref_key scope type targetNamespace)
);

#------------------------------------------------------------
sub new {
    my $class = shift;
    my $self  = {@_};
    return bless $self, $class;
}

#------------------------------------------------------------
sub key {
    my $self = shift;
    if (@_) {
        return ( $self->{key} = shift );
    }
    if ( exists $self->{key} ) {
        return $self->{key};
    }

    # WAS
    #	return $self->name;

    # Let's take a ride towards namespace support
    my $name = $self->name;

    return $name if ( $name =~ /\|/ );

    my $ns = $self->targetNamespace || '';
    return $self->name . ( $ns ? '|' . $ns : "" );
}

#------------------------------------------------------------
sub ref_key {
    my $self = shift;
    if (@_) {
        return ( $self->{ref_key} = shift );
    }
    if ( exists $self->{ref_key} ) {
        return $self->{ref_key};
    }

    # WAS
    #	return $self->ref();

    # Let's take a ride towards namespace support
    return undef unless $self->ref();

    my $ref = $self->ref;

    return $ref if ( $ref =~ /\|/ );
    my $ns = $self->targetNamespace || '';
    return $self->ref() . ( $ns ? '|' . $ns : "" );
}

#------------------------------------------------------------
# Set multiple fields (hash values) of this object all at once from a given
# hash.
sub set_fields {
    my $self = shift;
    my $h    = $_[0];    # if the first argument is a hash-ref, use it.

    # otherwise, use the argument list as a hash.
    unless ( ref($h) =~ /HASH/ ) {
        $h = {@_};
    }
    while ( my ( $key, $value ) = each %$h ) {
        $self->{$key} = $value;
    }
    return $self;
}

#----------------------------------------------------------
# override the accessor -- only for GET.
# Default to the value in "definition" if there is one.
sub class {
    my $self = shift;

    # _class_accesor is an alias for class() made by Class::Accessor
    # We are not interested by the SET case which should do the default.
    return $self->_class_accessor(@_) if (@_);

    # if we have it defined here, just return it.
    my $result = $self->_class_accessor();
    return $result if $result;

  # Otherwise, see if our "definition" has it. So we would effectively delegate.
    my $definition = undef;
    return $result
      unless ( UNIVERSAL::can( $self, "definition" )
        && ( $definition = $self->definition )
        && UNIVERSAL::can( $definition, "class" ) );
    return $definition->class();
}

#----------------------------------------------------------
# override the accessor -- only for GET.
# Default to the value in "definition" if there is one.
sub type {
    my $self = shift;

    # _type_accesor is an alias for type() made by Class::Accessor
    # We are not interested by the SET case which should do the default.
    return $self->_type_accessor(@_) if (@_);

    # if we have it defined here, just return it.
    my $result = $self->_type_accessor();
    return $result if $result;

  # Otherwise, see if our "definition" has it. So we would effectively delegate.
    my $definition = undef;
    return $result
      unless ( UNIVERSAL::can( $self, "definition" )
        && ( $definition = $self->definition )
        && UNIVERSAL::can( $definition, "type" ) );
    return $definition->type();
}

1;

__END__

=head1 NAME

B<Corinna::Schema::Object> - Ancestor of all Pastor schema object classes.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much about this module to actually use L<Corinna>.  It is 
documented here for completeness and for L<Corinna> developers. Do not count on the interface of this module. It may change in 
any of the subsequent releases. You have been warned. 

=head1 ISA

This class descends from L<Class::Accessor>. 

=head1 SYNOPSIS
  
  my $object = Corinna::Schema::Object->new();
  
  $object->set_fields(name => 'country', scope=> 'global', name_is_auto_generated=>0);
  $object->type('Country');
  
  print $object->name();	# prints 'country'.
  print $object->scope();	# prints 'global'.
  print $object->type();	# prints 'Country'.
  

=head1 DESCRIPTION

B<Corinna::Schema::Object> is an B<abstract> ancestor of all L<Corinna> schema object classes. 
Schema object classes are those that are the construction blocks of a B<schema model> (see L<Corinna::Schema::Model>). 
They also constitute the objects that contain the meta information about a W3C schema that are embedded 
as class data within the generated Perl classes by L<Corinna>.

Some examples of schema object classes include:

=over

=item L<Corinna::Schema::Type>

=item L<Corinna::Schema::SimpleType>

=item L<Corinna::Schema::ComplexType>

=item L<Corinna::Schema::Element>

=item L<Corinna::Schema::Group>

=item L<Corinna::Schema::Attribute>

=item L<Corinna::Schema::AttributeGroup>

=back


=head1 METHODS

=head2 CONSTRUCTORS
 
=head4 new() 

  $class->new(%fields)

B<CONSTRUCTOR>.

The new() constructor method instantiates a new object. It is inheritable. 
Normally, one does not call the B<new> method on B<Corinna::Schema::Object>. One rather
calls it on the descendant subclasses.
  
Any -named- fields that are passed as parameters are initialized to those values within
the newly created object. 

.

=head2 ACCESSORS

=head4 class()

  my $class = $object->class();	# GET
  $object->class($class);	    # SET
  
This is the Perl class that corresponds to the schema object. It is computed at 
schema model I<resolution> time. (see L<Corinna::Schema::Model/resolve()>).

This accessor is originally created by a call to B<mk_accessors> from L<Class::Accessor>.
However, it is further overridden in the source code in order to take into consideration the
I<definition> of the object. The SET functionality works as usual, but the GET functionality 
works as follows: If a value is NOT already defined for this field, but if there is a I<definition> 
of this object, then the value of the same field is returned from the I<definition> of the object. 
(See L</definition()>).

=head4 definition()

  my $definition = $object->definition();	# GET
  $object->definition($definition);  	    # SET
  
This field corresponds to the perl reference (ref) to a resolved W3C reference to a global object.
It is normally used for elements and attributes. This way, the local element definition is preserved 
while having a pointer to the actual global definition.

This field is set during the schema model I<resolution> time (see L<Corinna::Schema::Model/resolve()>).

This accessor is created by a call to B<mk_accessors> from L<Class::Accessor>.

=head4 key()

  my $key = $object->key();	# GET
  $object->key($key);  	    # SET
  
Returns the B<hash key> that is to be use to hash this object within the model. This is used 
by the B<add()> method of the schema model (see L<Corinna::Schema::Model/add()>). If no B<key> has
been previously set, it returns the B<name> of the object.

This accessor is coded manually.

=head4 id()

  my $id = $object->id();	# GET
  $object->id($id);  	    # SET

This is a W3C property. 

A schema object can have an ID within the W3C schema. Currently, this property is not used 
by L<Corinna>.

=head4 is_redefinable()

  my $bool = $object->is_redefinable();	# GET
  $object->is_redefinable($bool);  	    # SET

Normally, when an object is not marked as I<'redefinable'>, it is an error to attempt to define it again within
the schema model. (see L<Corinna::Schema::Model/add()>).
  
When processing a schema within a 'redefine' block, all schema objects (including types and elements) are
marked as I<redefinable>. This way, any subsequent redefinition in the model does not cause an error. 

This accessor is created by a call to B<mk_accessors> from L<Class::Accessor>.

=head4 name()

  my $name = $object->name();	# GET
  $object->name($name);  	    # SET

This is a W3C property. 
  
This field is the B<name> of the schema object as defined within the W3C schema or as attributed by the parser. 
Normally, all global objects (type, element, group, attribute, attributeGroup) will have a named defined in the W3C schema.
However, non-global objects (such as local elements) will not have a name that comes from the W3C schema. Such objects
will be named by the parser.

This accessor is created by a call to B<mk_accessors> from L<Class::Accessor>.

=head4 name_is_auto_generated()

  my $bool = $object->name_is_auto_generated();	# GET
  $object->name_is_auto_generated($bool);  	    # SET
  
Normally, all global objects (type, element, group, attribute, attributeGroup) will have a named defined in the W3C schema.
However, non-global objects (such as local elements) will not have a name that comes from the W3C schema. Such objects
will be named by the parser. In this case (when the name is generated automatically), this field will be set to TRUE(1) by 
the parser on the corresponding sceham object.

This accessor is created by a call to B<mk_accessors> from L<Class::Accessor>.

=head4 ref()

  my $ref = $object->ref();	# GET
  $object->ref($ref);  	    # SET

This is a W3C property. 
  
Sometimes in a W3C schema, a local object (such as an element) makes a reference to a global object (such as 
a global element). In this case, the B<'ref'> field will contain the name of the referenced global object. 

The value of this field comes directly from the W3C schema, and is put into this field by the schema parser. 

This accessor is created by a call to B<mk_accessors> from L<Class::Accessor>.

=head4 scope()

  my $scope = $object->scope();	# GET
  $object->scope($scope);  	    # SET
  
All schema objects are defined within a scope. The scope can be I<'global'> or I<'local'>. 
The scope of schema objects are determined by the schema parser and this field is set accordingly at
parse time.

This accessor is created by a call to B<mk_accessors> from L<Class::Accessor>.

=head4 type()

  my $type = $object->type();	# GET
  $object->type($type);  	    # SET

This is a W3C property. 
  
Sometimes in a W3C schema, an object (such as an attribute or an element) will refer to a B<type> that is
defined globally in the schema set. The value of this field comes directly from the W3C schema, 
and is put into this field by the schema parser. 

This accessor is originally created by a call to B<mk_accessors> from L<Class::Accessor>.
However, it is further overridden in the source code in order to take into consideration the
I<definition> of the object. The SET functionality works as usual, but the GET functionality 
works as follows: If a value is NOT already defined for this field, but if there is a I<definition> 
of this object, then the value of the same field is returned from the I<definition> of the object. 
(See L</definition()>).


=head2 OTHER METHODS

=head4 set_fields()

  $object->set_fields(%fields);

B<OBJECT METHOD>.

This method is used to set multiple fields of a schema object all at once. From an
interface point of view, it is like the B<new()> method, but instead of constructing
a new object, it works on an existing object. 

Example :

  $object->set_fields(
                     name=> country,
                     scope=>global
                     );
                     
This is used heavily by the parser in order to set multiple fields that are obtained by
parsing attributes from the schema nodes.


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
