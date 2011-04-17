use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);


#======================================================================
package Corinna::Builtin::date;

use Corinna::Builtin::Scalar;

our @ISA = qw(Corinna::Builtin::Scalar);

use Corinna::Util qw(validate_date);

Corinna::Builtin::date->XmlSchemaType( bless( {
                 'class' => 'Corinna::Builtin::date',
                 'contentType' => 'simple',
                 'derivedBy' => 'restriction',
                 'name' => 'date|http://www.w3.org/2001/XMLSchema',                 
                 'regex' => qr /^[-]?(\d{4,})-(\d\d)-(\d\d)(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/,  # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
               }, 'Corinna::Schema::SimpleType' ) );


#--------------------------------------------------------
# returns a DateTime object representing the value.
#--------------------------------------------------------
sub to_date_time() {
	my $self  = shift;
	my $value = $self->__value;
	
	unless ($value =~ /^[-]?(\d{4,})-(\d\d)-(\d\d)/) {
		die "Pastor: Invalid date '$value'!";
	}
	my ($year, $month, $day)  = ($1, $2, $3);
	$year = -$year if ($value =~ /^[-]/);	# Catch negative year.
	
	require DateTime;		
	my  $dt = DateTime->new( year   => $year, 
							month  => $month,
                       		day    => $day,
                         	hour   => 0, minute => 0, second => 0);
	
	return $dt;
}


#--------------------------------------------------------
# CONSTRUCTOR. Creates a new object and sets the value from 
# a DateTime object.
#--------------------------------------------------------
sub from_date_time($) {
	my $self = shift->new();
	$self->set_from_date_time(shift);	
}

#--------------------------------------------------------
# sets the value from a DateTime object.
#--------------------------------------------------------
sub set_from_date_time($) {
	my $self = shift;
	my $dt 	 = shift;

	require DateTime;		
	require DateTime::Format::W3CDTF;

	my $f = DateTime::Format::W3CDTF->new;
	$self->value($f->format_date($dt));	
}



#--------------------------------------------------------
# OVERRIDDEN from Corinna::SimpleType
#--------------------------------------------------------
sub xml_validate_further {
	my $self  = shift;
	my $value = $self->__value;
	
	$value =~ /^[-]?(\d{4,})-(\d\d)-(\d\d)/;
	return validate_date($1, $2, $3);	
}


1;

__END__

=head1 NAME

B<Corinna::Builtin::date> - Class for the B<W3C builtin> type B<date>.

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much about this module to actually use L<Corinna>.  It is 
documented here for completeness and for L<Corinna> developers. Do not count on the interface of this module. It may change in 
any of the subsequent releases. You have been warned. 

=head1 ISA

This class descends from L<Corinna::Builtin::Scalar>. 

=head1 DESCRIPTION

B<Corinna::Builtin::date> represents the B<builtin> W3C type 
B<date>. 

=head1 METHODS

=head2 INHERITED METHODS

This class inherits many methods from its ancestors. Please see L<Corinna::Builtin::Scalar> for 
more methods. 

=head2 CONSTRUCTORS
 
=head4 from_date_time() 

  my $object = Corinna::Builtin::date->from_date_time($dt);

B<CONSTRUCTOR>. 

The B<from_date_time()> constructor method instantiates a new object from L<DateTime> object. 
It is inheritable. The necessary conversion is done within the method.	


=head2 OTHER METHODS

=head4 set_from_date_time()

	$object->set_from_date_time($dt);
	
This method sets the value of the object from a L<DateTime> object. 
The necessary conversion is done within the method.	

=head4 to_date_time()

	my $dt = $object->to_date_time();
	
This method returns the value of the object as a L<DateTime> object. 
The necessary conversion is done within the method.	

=head4 xml_validate_further()

This method is overriden from L<Corinna::SimpleType> so that B<date> values 
can be checked for logical inconsistencies. For example, a B<month> value of I<14> will
cause an error (die).

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

See also L<Corinna>, L<Corinna::ComplexType>, L<Corinna::SimpleType>, L<Corinna::Builtin>, L<DateTime>

If you are curious about the implementation, see L<Corinna::Schema::Parser>,
L<Corinna::Schema::Model>, L<Corinna::Generator>.

=cut


