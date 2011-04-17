package Corinna::Schema::Model;
use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);

use Data::Dumper;
use Class::Accessor;

use Corinna::Schema::Object;
use Corinna::Schema::NamespaceInfo;

use Corinna::Util qw(merge_hash);

our @ISA = qw(Class::Accessor);

Corinna::Schema::Model->mk_accessors(
    qw(type element group attribute attributeGroup defaultNamespace namespaces namespaceCounter)
);

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {@_};

    unless ( $self->{type} ) {
        $self->{type} = {};
    }
    unless ( $self->{element} ) {
        $self->{element} = {};
    }

    unless ( $self->{group} ) {
        $self->{group} = {};
    }

    unless ( $self->{attribute} ) {
        $self->{attribute} = {};
    }

    unless ( $self->{attributeGroup} ) {
        $self->{attributeGroup} = {};
    }

    unless ( $self->{namespaces} ) {
        $self->{namespaces} = {};
    }

    unless ( $self->{namespaceCounter} ) {
        $self->{namespaceCounter} = 0;
    }

    return bless $self, $class;
}

#-------------------------------------------------------
sub xml_item {
    my $self    = shift;
    my $name    = shift;
    my $nsUri   = shift;
    my $verbose = 0;

    if ( !$nsUri && $self->defaultNamespace ) {
        $nsUri = $self->defaultNamespace()->uri();
    }

    my $key = $nsUri ? "$name|$nsUri" : $name;

    print STDERR "Model item: name = '$name',   key = '$key'\n"
      if ( $verbose >= 9 );
    my $item;
    foreach my $hname (qw(element type group attribute attributeGroup)) {
        my $items = $self->{$hname};
        $item = $items->{$key};
        last if defined($item);
    }

    print STDERR "Found item: name = '$name'\n"
      if ( defined($item) && ( $verbose >= 9 ) );

    return $item;

}

#-------------------------------------------------------
sub xml_item_class {
    my $self = shift;
    my $item = $self->xml_item(@_);

    return undef unless ( defined($item) );
    return $item->class || ( $item->definition && $item->definition->class );
}

#-------------------------------------------------------
sub add {
    my $self = shift;
    my $args = {@_};
    my $field;
    my $newItem;

    unless ( defined($field) ) {
        $newItem = $args->{object} || $args->{item} || $args->{node};
      SWITCH: {
            UNIVERSAL::isa( $newItem, "Corinna::Schema::Type" )
              and do { $field = "type"; last SWITCH; };
            UNIVERSAL::isa( $newItem, "Corinna::Schema::Element" )
              and do { $field = "element"; last SWITCH; };
            UNIVERSAL::isa( $newItem, "Corinna::Schema::Group" )
              and do { $field = "group"; last SWITCH; };
            UNIVERSAL::isa( $newItem, "Corinna::Schema::Attribute" )
              and do { $field = "attribute"; last SWITCH; };
            UNIVERSAL::isa( $newItem, "Corinna::Schema::AttributeGroup" )
              and do { $field = "attributeGroup"; last SWITCH; };
        }
    }

    unless ( defined($field) ) {
        foreach my $arg (qw(type element group attribute attributeGroup)) {
            if ( defined( $args->{$arg} ) ) {
                $field   = $arg;
                $newItem = $args->{$field};
                last;
            }
        }
    }

    unless ( defined($field) ) {
        return undef;
    }

    my $items = $self->{$field};
    my $key =
      UNIVERSAL::can( $newItem, "key" )
      ? $newItem->key()
      : ( UNIVERSAL::can( $newItem, "name" ) ? $newItem->name : '_anonymous_' );
    if ( defined( my $oldItem = $items->{$key} ) ) {
        unless ( UNIVERSAL::can( $oldItem, 'isRedefinable' )
            && $oldItem->isRedefinable() )
        {
            die "Pastor : $field already defined : '$key'\\n";
        }
    }
    $newItem->isRedefinable(1)
      if ( $args->{operation} !~ /redefine/i )
      && UNIVERSAL::can( $newItem, 'isRedefinable' );
    $items->{$key} = $newItem;

}

#-------------------------------------------------------
sub add_namespace_uri {
    my $self    = shift;
    my $uri     = shift;
    my $verbose = $self->{verbose} || 0;

    return undef unless ( defined($uri) );

    my $nsh = $self->namespaces();

    print STDERR "*** Adding Namespace URI to the schema model => '$uri'\n"
      if ( $verbose >= 5 );

    if ( exists( $nsh->{$uri} ) ) {

        # URI is already in use
        my $ns = $nsh->{$uri};
        $ns->usage_count( $ns->usage_count + 1 );
        return $ns;
    }
    else {

        # URI is not already there
        my $nsPfx    = undef;
        my $classPfx = undef;
        my $id       = 0;

        # The counter serves for id purposes.
        my $nsc = $self->namespaceCounter();

        if ($nsc) {

            # There is at least one other target namespace alreday in there
            $id       = $nsc + 1;
            $nsPfx    = "ns" . sprintf( "%03d", $id );
            $classPfx = $nsPfx;
        }

        # Add the URI to the namspace hash
        my $ns = Corinna::Schema::NamespaceInfo->new(
            uri          => $uri,
            id           => $id,
            usage_count  => 1,
            ns_prefix    => $nsPfx,
            class_prefix => $classPfx
        );
        $nsh->{$uri} = $ns;

        # This is the first namespace that is declared. Make it the default.
        unless ($nsc) {
            $self->defaultNamespace($ns);
        }

        # Increment the id counter
        $self->namespaceCounter( $self->namespaceCounter + 1 );

        return $ns;
    }

}

#-------------------------------------------------------
sub get_item {
    my $self = shift;
    my $args = {@_};
    my $field;
    my $itemName;

    unless ( defined($field) ) {
        foreach my $arg (qw(type element group attribute attributeGroup)) {
            if ( defined( $args->{$arg} ) ) {
                $field    = $arg;
                $itemName = $args->{$field};
                last;
            }
        }
    }

    unless ( defined($field) ) {
        return undef;
    }

    my $items = $self->{$field};
    return $items->{$itemName};
}

#------------------------------------------------------------------
sub dump {
    my $self = shift;
    my $d = Data::Dumper->new( [$self] );
    $d->Sortkeys(1);

    #	$d->Deepcopy(1);
    #	$d->Terse(1);
    return $d->Dump();
}

#------------------------------------------------------------------
sub resolve {
    my $self    = shift;
    my $opts    = {@_};
    my $verbose = $opts->{verbose} || 0;

    print "\n==== Resolving schema model ... ====\n" if ( $verbose >= 3 );

    $self->_resolve($opts);
}

#------------------------------------------------------------------
sub _resolve {
    my $self = shift;
    my $opts = shift;
    my $hashList =
      [ $self->group(), $self->attributeGroup, $self->type(),
        $self->element() ];

    foreach my $items (@$hashList) {
        foreach my $name ( sort keys %$items ) {
            $self->_resolve_object( $items->{$name}, $opts );

        }
    }
}

#------------------------------------------------------------------
sub _resolve_object {
    my $self   = shift;
    my $object = shift;
    my $opts   = shift;

    $self->_resolve_object_ref( $object, $opts );
    $self->_resolve_object( $object->definition(), $opts )
      if ( $object->definition() );

    $self->_resolve_object_attributes( $object, $opts );
    $self->_resolve_object_elements( $object, $opts );

    $self->_resolve_object_class( $object, $opts );
    $self->_resolve_object_base( $object, $opts );

    return $object;
}

#------------------------------------------------------------------
sub _resolve_object_ref {
    my $self    = shift;
    my $object  = shift;
    my $opts    = shift;
    my $verbose = $opts->{verbose} || 0;

    return $object
      unless ( UNIVERSAL::can( $object, "ref" ) && $object->ref() );

    print STDERR "  Resolving REFERENCES for object '"
      . $object->name
      . "' ...\n"
      if ( $verbose >= 6 );

    my $field = undef;

  SWITCH: {
        UNIVERSAL::isa( $object, "Corinna::Schema::Type" )
          and do { $field = "type"; last SWITCH; };
        UNIVERSAL::isa( $object, "Corinna::Schema::Element" )
          and do { $field = "element"; last SWITCH; };
        UNIVERSAL::isa( $object, "Corinna::Schema::Group" )
          and do { $field = "group"; last SWITCH; };
        UNIVERSAL::isa( $object, "Corinna::Schema::Attribute" )
          and do { $field = "attribute"; last SWITCH; };
        UNIVERSAL::isa( $object, "Corinna::Schema::AttributeGroup" )
          and do { $field = "attributeGroup"; last SWITCH; };
    }

    print STDERR "   Reference is $field\n" if ( $verbose >= 9 );

    my $hash    = $self->{$field};
    my $ref_key = $object->ref_key;

    print STDERR "   Resolving reference for '$ref_key'\n" if ( $verbose >= 9 );

    my $def = $hash->{$ref_key};
    $object->definition($def);

    return $def;
}

#------------------------------------------------------------------
sub _resolve_object_class {
    my $self    = shift;
    my $object  = shift;
    my $opts    = shift;
    my $verbose = $opts->{verbose} || 0;
    $opts->{object} = $object;

    my $class_prefix = $opts->{class_prefix} || '';
    while ( ($class_prefix) && ( $class_prefix !~ /::$/ ) ) {
        $class_prefix .= ':';
    }

    print STDERR "  Resolving CLASS for object '" . $object->name . "' ... \n"
      if ( $verbose >= 6 );

    if ( UNIVERSAL::can( $object, "metaClass" ) ) {
        $object->metaClass( $class_prefix . "Pastor::Meta" );
    }

    if ( UNIVERSAL::isa( $object, "Corinna::Schema::Type" ) ) {
        print "   object '"
          . $object->name
          . "' is a Type. Resolving class...\n"
          if ( $verbose >= 7 );
        $object->class( $self->_type_to_class( $object->name(), $opts ) );
    }
    elsif ( UNIVERSAL::isa( $object, "Corinna::Schema::Element" )
        && ( $object->scope() =~ /global/ ) )
    {
        print "   object '"
          . $object->name
          . "' is a global element. Resolving class...\n"
          if ( $verbose >= 7 );
        my $uri =
          UNIVERSAL::can( $object, 'targetNamespace' )
          ? $object->targetNamespace
          : "";
        my $pfx = $uri ? $self->namespace_class_prefix($uri) : "";
        $object->class( $class_prefix . $pfx . $object->name() );
    }
    elsif (UNIVERSAL::can( $object, "type" )
        && UNIVERSAL::can( $object, "class" ) )
    {
        print "   object '"
          . ( $object->name || '' )
          . "' 'can' type() and class(). TYPE='"
          . ( $object->type() || '' )
          . "' CLASS='"
          . ( $object->class() || '' )
          . "' Resolving class...\n"
          if ( $verbose >= 7 );

        $object->class( $self->_type_to_class( $object->type(), $opts ) );
    }

    if (   UNIVERSAL::can( $object, "itemType" )
        && UNIVERSAL::can( $object, "itemClass" )
        && $object->itemType )
    {
        print "   object '"
          . $object->name
          . "' 'can' itemType() and itemClass(). Resolving class...\n"
          if ( $verbose >= 7 );
        $object->itemClass( $self->_type_to_class( $object->itemType, $opts ) );
    }

    if (   UNIVERSAL::can( $object, "memberTypes" )
        && UNIVERSAL::can( $object, "memberClasses" )
        && $object->memberTypes )
    {
        print "   object '"
          . $object->name
          . "' 'can' memberTypes() and memberClasses(). Resolving class...\n"
          if ( $verbose >= 7 );
        my @mbts = split ' ', $object->memberTypes;
        $object->memberClasses(
            [ map { $self->_type_to_class( $_, $opts ); } @mbts ] );
    }

    if ( UNIVERSAL::can( $object, "baseClasses" ) ) {
        print "   object '"
          . $object->name
          . "' 'can' baseClasses(). Resolving class...\n"
          if ( $verbose >= 7 );

        if ( UNIVERSAL::can( $object, "base" ) && $object->base() ) {

            $object->baseClasses(
                [ $self->_type_to_class( $object->base(), $opts ) ] );
        }
        elsif (UNIVERSAL::isa( $object, "Corinna::Schema::Element" )
            && $object->type()
            && ( $object->scope() =~ /global/ ) )
        {
            $object->baseClasses(
                [
                    $self->_type_to_class( $object->type(), $opts ),
                    "Corinna::Element"
                ]
            );
        }
        elsif ( UNIVERSAL::isa( $object, "Corinna::Schema::SimpleType" ) ) {
            my $isa = $opts->{simple_isa};
            $isa = ( ( ref($isa) =~ /ARRAY/ ) ? $isa : ( $isa ? [$isa] : [] ) );
            $object->baseClasses( [ @$isa, "Corinna::SimpleType" ] );
        }
        elsif ( UNIVERSAL::isa( $object, "Corinna::Schema::ComplexType" ) ) {
            my $isa = $opts->{complex_isa};
            $isa = ( ( ref($isa) =~ /ARRAY/ ) ? $isa : ( $isa ? [$isa] : [] ) );
            $object->baseClasses( [ @$isa, "Corinna::ComplexType" ] );
        }
    }

    return $object;
}

#------------------------------------------------------------------
sub _resolve_object_attributes {
    my $self    = shift;
    my $object  = shift;
    my $opts    = shift;
    my $verbose = $opts->{verbose} || 0;

    return undef unless ( UNIVERSAL::can( $object, "attributes" ) );
    print STDERR "  Resolving ATTRIBUTES for object '"
      . $object->name
      . "' ...\n"
      if ( $verbose >= 6 );

    my $attributes = $object->attributes();
    my $attribInfo = $object->attributeInfo();
    my $newAttribs = [];

    foreach my $attribName (@$attributes) {
        my $attrib = $attribInfo->{$attribName};
        $self->_resolve_object( $attrib, $opts );

        unless ( UNIVERSAL::isa( $attrib, "Corinna::Schema::Attribute" ) ) {
            my $a =
              ( UNIVERSAL::can( $attrib, "definition" )
                  && $attrib->definition() )
              || $attrib;
            push @$newAttribs, @{ $a->attributes() }
              if UNIVERSAL::can( $a, "attributes" );
            merge_hash( $attribInfo, $a->attributeInfo() )
              if UNIVERSAL::can( $a, "attributeInfo" );
        }
        else {
            push @$newAttribs, $attribName;
        }
    }

    $object->attributes($newAttribs);
    return $object;
}

#------------------------------------------------------------------
sub _resolve_object_elements {
    my $self    = shift;
    my $object  = shift;
    my $opts    = shift;
    my $verbose = $opts->{verbose} || 0;

    return undef unless ( UNIVERSAL::can( $object, "elements" ) );

    print STDERR "  Resolving ELEMENTS for object '" . $object->name . "' ...\n"
      if ( $verbose >= 6 );

    my $elements = $object->elements();
    my $elemInfo = $object->elementInfo();
    my $newElems = [];

    foreach my $elemName (@$elements) {
        my $elem = $elemInfo->{$elemName};
        $self->_resolve_object( $elem, $opts );

        unless ( UNIVERSAL::isa( $elem, "Corinna::Schema::Element" ) ) {
            my $e =
              ( UNIVERSAL::can( $elem, "definition" ) && $elem->definition() )
              || $elem;
            push @$newElems, @{ $e->elements() }
              if UNIVERSAL::can( $e, "elements" );
            merge_hash( $elemInfo, $e->elementInfo() )
              if UNIVERSAL::can( $e, "elementInfo" );
        }
        else {
            push @$newElems, $elemName;
        }
    }

    $object->elements($newElems);
    return $object;
}

#------------------------------------------------------------------
sub _resolve_object_base {
    my $self    = shift;
    my $object  = shift;
    my $opts    = shift;
    my $verbose = $opts->{verbose} || 0;

    return undef
      unless ( UNIVERSAL::can( $object, "base" ) && $object->base() );
    print STDERR "  Resolving BASE for object '" . $object->name . "' ...\n"
      if ( $verbose >= 6 );

    my $base     = $object->base();
    my $types    = $self->type();
    my $baseType = $types->{$base};

    return undef unless ($baseType);
    $self->_resolve_object( $baseType, $opts );

    if ( UNIVERSAL::can( $object, "xAttributes" ) ) {
        my $xattribs    = [];
        my $xattribInfo = {};

        if (UNIVERSAL::can($baseType, 'effective_attributes')) {
            push @$xattribs, @{ $baseType->effective_attributes() };
            merge_hash( $xattribInfo, $baseType->effective_attribute_info() );
        }

        push @$xattribs, @{ $object->attributes() };
        merge_hash( $xattribInfo, $object->attributeInfo() );

        print ' ' . scalar(@$xattribs) . ' attributes. ' if ( $verbose >= 5 );

        if (@$xattribs) {
            $object->xAttributes($xattribs);
            $object->xAttributeInfo($xattribInfo);
        }
    }

    if ( UNIVERSAL::can( $object, "xElements" ) ) {
        my $xelems    = [];
        my $xelemInfo = {};

        if (UNIVERSAL::can($baseType, 'effective_elements')) {
            push @$xelems, @{ $baseType->effective_elements() };
            merge_hash( $xelemInfo, $baseType->effective_element_info() );
        }

        push @$xelems, @{ $object->elements() };
        merge_hash( $xelemInfo, $object->elementInfo() );

        #		print ' ' . scalar(@$xelems) . ' elements. ';
        if (@$xelems) {
            $object->xElements($xelems);
            $object->xElementInfo($xelemInfo);
        }
    }

    return $object;
}

#------------------------------------------------------------------
sub _type_to_class {
    my $self      = shift;
    my $type      = shift;
    my $opts      = shift;
    my $object    = $opts->{object};
    my $isNonType = $opts->{isNonType} || 0;
    my $typePfx   = $isNonType ? "" : "Type::";
    my $verbose   = 0;

    return undef unless ( defined($type) );

    my $class_prefix = $opts->{class_prefix} || "";
    while ( ($class_prefix) && ( $class_prefix !~ /::$/ ) ) {
        $class_prefix .= ':';
    }

    my $builtin_prefix = "Corinna::Builtin::";
    if ( ( $type =~ /^Union$/i ) || ( $type =~ /^List$/i ) ) {

        # This one is put by the parser. So we don't have a URI for it.
        return $builtin_prefix . ucfirst($type);
    }
    elsif ( !$type ) {

        # No type declaration, assume string
        return $builtin_prefix . "string";
    }
    elsif ( $type =~ /www.w3.org\/.*\/XMLSchema$/ ) {

        # Builtin type
        my ($localType) = split /\|/, $type;
        return $builtin_prefix . $localType;
    }
    elsif ( $type =~ /\|/ ) {

        # Type with a namespace.
        my ( $localType, $uri ) = split /\|/, $type;
        my $pfx = $self->namespace_class_prefix($uri);

        my $retval = $class_prefix . $pfx . $typePfx . $localType;
        print STDERR "_type_to_class: from '$type'   to    '$retval'\n"
          if ( $verbose >= 9 );

        return $retval;

        #die "Pastor: Namespaces not yet supported!\n";
    }
    else {

        # Regular type.
        my $uri =
          UNIVERSAL::can( $object, 'targetNamespace' )
          ? $object->targetNamespace
          : "";
        my $pfx = $uri ? $self->namespace_class_prefix($uri) : "";
        return $class_prefix . $pfx . $typePfx . $type;
    }
}

#-------------------------------------------------------
sub namespace_class_prefix {
    my $self = shift;
    my $uri  = shift;

    my $ns = $self->namespaces->{$uri};
    my $pfx = defined($ns) ? ( $ns->class_prefix() || "" ) : "";
    while ( ($pfx) && ( $pfx !~ /::$/ ) ) {
        $pfx .= ':';
    }

    return $pfx;
}

1;

__END__

=head1 NAME

B<Corinna::Schema::Model> - Class representing an internal W3C schema model (info set) for L<Corinna>.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much about this module to actually use L<Corinna>.  It is 
documented here for completeness and for L<Corinna> developers. Do not count on the interface of this module. It may change in 
any of the subsequent releases. You have been warned. 

=head1 ISA

This class descends from L<Class::Accessor>. 

=head1 SYNOPSIS

  my $model = Corinna::Schema::Model->new();
  
  $model->add(object->$object1);
  $model->add(object->$object2);
  $model->add(object->$object3);
  
  $model->resolve();

=head1 DESCRIPTION

B<Corinna::Schema::Model> is used internally by L<Corinna> for representinng the parsed information set 
of a group of W3C schemas. 

A B<model> is produced typically by parsing with the L<Corinna::Schema::Parser/parse()> method. However, it is theoratically 
possible to produce it by other means. 

A B<model> contains information about all the I<type, element, attribute, group, and attribute group> definitions that come from the set of 
schemas that constitute the I<source> of the model. This includes all global and implicit types and elements.

Once produced, you can't do much with a model except B<resolve> it. Resolving the model means things such as resolving all references (such as 
those pointing to global elements or groups) and computing the Perl class names that correspond to each generated class. See L</resolve()> for more 
details.

Once resolved, the model is then ready to be used for code generation. 

=head1 METHODS

=head2 CONSTRUCTORS
 
=head4 new() 

  Corinna::Schema::Model->new(%fields)

B<CONSTRUCTOR>.

The new() constructor method instantiates a new object. It is inheritable. 
  
Any -named- fields that are passed as parameters are initialized to those values within
the newly created object. 

The B<new()> method will create the I<type>, I<element>, I<attribute>, I<group>, and I<attributeGroup> fields 
if it is not passed values for those fields.

.

=head2 ACCESSORS
 
=head4 type() 

A hash of all (global and implicit) type definitions (simple or complex) that are obtained from the processed W3C schemas.
The hash key is the name of the B<type> and the value is an object of type L<Corinna::Schema::SimpleType> or L<Corinna::Schema::ComplexType>, 
depending on whether this is a simple or complex type.

A straight forward consequence is that simple and complex types cannot have name collisions among each other. This conforms with the W3C specifications.

Note that this hash is obtained from a merge of all the information coming from the various W3C schemas. So it represents information coming from all the concerned schemas.

Note that each item of this hash later becomes a generated class under the "Type" subtree when code generation is performed  

=head4 element() 

A hash of all global elements obtained from the W3C schemas. The hash key is the name of the global element and the value is an object
of type L<Corinna::Schema::Element>.

Note that this hash is obtained from a merge of all the information coming from the various W3C schemas. So it represents information coming from all the concerned schemas.

Note that each item of this hash later becomes a generated class when code generation is performed. 

=head4 attribute() 

A hash of all global attributes obtained from the W3C schemas. The hash key is the name of the global attribute and the value is an object
of type L<Corinna::Schema::Attribute>.

Note that this hash is obtained from a merge of all the information coming from the various W3C schemas. So it represents information coming from all the concerned schemas.

Note that no code generation is perfomed for the items in this hash. They are used internally by the "type" hash once the referenes to them are resolved.

=head4 group() 

A hash of all global groups obtained from the W3C schemas. The hash key is the name of the global group and the value is an object
of type L<Corinna::Schema::Group>.

Note that this hash is obtained from a merge of all the information coming from the various W3C schemas. So it represents information coming from all the concerned schemas.

Note that no code generation is perfomed for the items in this hash. They are used internally by the "type" hash once the referenes to them are resolved.

=head4 attributeGroup() 

A hash of all global attribute groups obtained from the W3C schemas. The hash key is the name of the global attribute group and the value is an object
of type L<Corinna::Schema::AttributeGroup>.

Note that this hash is obtained from a merge of all the information coming from the various W3C schemas. So it represents information coming from all the concerned schemas.

Note that no code generation is perfomed for the items in this hash. They are used internally by the "type" hash once the referenes to them are resolved.

.

=head2 OTHER METHODS

=head4 add()

	$model->add(object=>$object);
	
Add a schema object to the model (to the corresponding hash). 
Aliases of 'object' are 'item' and 'node'. So the following are equivalent to the above:

	$model->add(item=>$object);
	$model->add(node=>$object);
	
In the above, the actual hash where the object will be placed is deduced from the type of the object.
Possible types are descendents of:

=over

=item L<Corinna::Schema::Type>	(where L<Corinna::Schema::SimpleType> and L<Corinna::Schema::ComplexType> descend.)

=item L<Corinna::Schema::Element>

=item L<Corinna::Schema::Group>

=item L<Corinna::Schema::Attribute>
		
=item L<Corinna::Schema::AttributeGroup>

=back
	
One can also pass the name of the hash that one would like the object to be added. Examples:

	$model->add(type=>$object);
	$model->add(element=>$object);
	$model->add(group=>$object);
	$model->add(attribute=>$object);
	$model->add(attributeGroup=>$object);
	
In this case, the type of the object is not taken into consideration.

Normally, when a schema object is already defined within the model, it is an error to attempt to add it
again to the model. This means that the object is defined twice in the W3C schema. However, this rule
is relaxed when the object within the sceham is marked as I<redefinable> (see L<Corinna::Schema::Object/isRedefinable()>). 
This is typically the case when we are in a I<redefine> block (when a schema is included wit the redefine tag). 

=head4 xml_item($name, [$nsUri])

Returns the Schema Model item for a given name, and optionally, a namespace URI. If namespace URI is omitted, then
the default namespace URI for the model is used.

This method does a search on the different hashes kept by the model (element, type, group, attribute, attributeGroup) in that order, and 
will return the first encountred item.
 
=head4 xml_item_class($name, [$nsUri])

Returns the class name of a Schema Model item for a given name, and optionally, a namespace URI. If namespace URI is omitted, then
the default namespace URI for the model is used.

This is in fact a shortcut for:
   $model->xml_item($name)->class();

 
=head4 resolve()
   
  $model->resolve(%options);

B<OBJECT METHOD>.

This method will I<resolve> the B<model>. In other words, thhis method will prepare the produced model to be
processed for code gerenartion.

Resolving a model means: resolving references to global objects (elements and attributes); replacing
group and attributeGroup references with actual contents of the referenced group; computing the Perl class 
names of the types and elements to be generated; and figuring out the inheritance relationships between classes.

The builtin classes are known to the method so that the Perl classes for them will not be generated but rather referenced 
from the L<Corinna::Builtin> module.

OPTIONS 

=over

=item class_prefix

If present, the names of the generated classes will be prefixed by this value. 
You may end the value with '::' or not, it's up to you. It will be autocompleted. 
In other words both 'MyApp::Data' and 'MyApp::Data::' are valid. 

=item complex_isa

Via this parameter, it is possible to indicate a common ancestor (or ancestors) of all complex types that are generated by B<Corinna>.
The generated complex types will still have B<Corinna::ComplexType> as their last ancestor in their @ISA, but they will also have the class whose  
name is given by this parameter as their first ancestor. Handy if you would like to add common behaviour to all your generated classes. 

This parameter can have a string value (the usual case) or an array reference to strings. In the array case, each item is added to the @ISA array (in that order) 
of the generated classes.

=item simple_isa

Via this parameter, it is possible to indicate a common ancestor (or ancestors) of all simple types that are generated by B<Corinna>.
The generated simple types will still have B<Corinna::SimpleType> as their last ancestor in their @ISA, but they will also have the class whose  
name is given by this parameter as their first ancestor. Handy if you would like to add common behaviour to all your generated classes. 

This parameter can have a string value (the usual case) or an array reference to strings. In the array case, each item is added to the @ISA array (in that order) 
of the generated classes.

=back

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

If you are curious about the implementation, see L<Corinna::Schema::Parser>, L<Corinna::Generator>

If you really want to dig in, see L<Corinna::Schema::Attribute>, L<Corinna::Schema::AttributeGroup>,
L<Corinna::Schema::ComplexType>, L<Corinna::Schema::Element>, L<Corinna::Schema::Group>,
L<Corinna::Schema::List>, L<Corinna::Schema::SimpleType>, L<Corinna::Schema::Type>, 
L<Corinna::Schema::Object>

=cut
