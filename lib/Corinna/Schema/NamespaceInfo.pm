package Corinna::Schema::NamespaceInfo;

use Moose;
use MooseX::UndefTolerant; # :(

has uri => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);
has ns_prefix => (
    is  => 'ro',
    isa => 'Str',
);
has class_prefix => (
    is  => 'ro',
    isa => 'Str',
);
has id => (
    is  => 'ro',
    isa => 'Str',
);
has usage_count => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

1;

__END__

=head1 NAME

B<Corinna::Schema::NamespaceInfo> - Class that represents the META information about a target namespace within a W3C schema.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much
about this module to actually use L<Corinna>.  It is documented here for
completeness and for L<Corinna> developers. Do not count on the interface of
this module. It may change in any of the subsequent releases. You have been
warned.

=head1 ISA

This class descends from L<Class::Accessor>.

=head1 DESCRIPTION

B<Corinna::Schema::NameSpaceInfo> is a class that is used internally to
represent a target namespace of a given schema.

=head1 METHODS

=head2 CONSTRUCTORS

=head4 new()

  $class->new(\%fields)

B<CONSTRUCTOR>, inherited.

The new() constructor method instantiates a new object. It is inheritable.

Any -named- fields that are passed as parameters are initialized to those values within
the newly created object.

.

=head2 ACCESSORS


=head3 Accessors defined here

=head4 uri()

  my $uri = $object->uri();	# GET
  $object->uri($uri);       # SET

The namespace URI associated.

=head4 ns_prefix()

  my $pfx = $object->ns_prefix();	# GET
  $object->ns_prefix($pfx);       # SET

The namespace prefix associated with this URI.

=head4 class_prefix()

  my $pfx = $object->class_prefix();	# GET
  $object->class_prefix($pfx);       # SET

The class prefix that will be used in conjunction with this target namespace.

=head4 id()

  my $id = $object->id();	# GET
  $object->id($id);       # SET

An identifier, local to the schema model, of this namespace.

.

=head1 BUGS & CAVEATS

There no known bugs at this time, but this doesn't mean there are aren't any.
Note that, although some testing was done prior to releasing the module, this should still be considered alpha code.
So use it at your own risk.

Note that there may be other bugs or limitations that the author is not aware of.

=head1 AUTHOR

Ayhan Ulusoy <dev(at)ulusoy(dot)name>


=head1 COPYRIGHT

  Copyright (C) 2006-2008 Ayhan Ulusoy. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=head1 SEE ALSO

See also L<Corinna>, L<Corinna::Schema::Model>

=cut
