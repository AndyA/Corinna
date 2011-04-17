package Corinna::Builtin;
use utf8;
use strict;
use warnings;
no warnings qw(uninitialized);

use Corinna::SimpleType;
use Corinna::Builtin::List;
use Corinna::Builtin::Scalar;
use Corinna::Builtin::Numeric;
use Corinna::Builtin::Union;

use Corinna::Builtin::base64Binary;
use Corinna::Builtin::boolean;
use Corinna::Builtin::date;
use Corinna::Builtin::dateTime;
use Corinna::Builtin::hexBinary;

#======================================================================
package Corinna::Builtin::string;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::string->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::string',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'string|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::token;
our @ISA = qw(Corinna::Builtin::string);

Corinna::Builtin::token->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::token',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'token|http://www.w3.org/2001/XMLSchema',
            'whiteSpace'  => 'collapse',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::integer;
our @ISA = qw(Corinna::Builtin::Numeric);

Corinna::Builtin::integer->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::integer',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'integer|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::nonNegativeInteger;
our @ISA = qw(Corinna::Builtin::integer);

Corinna::Builtin::nonNegativeInteger->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::nonNegativeInteger',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'minInclusive' => 0,
            'name' => 'nonNegativeInteger|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::nonPositiveInteger;
our @ISA = qw(Corinna::Builtin::integer);

Corinna::Builtin::nonPositiveInteger->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::nonPositiveInteger',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 0,
            'name' => 'nonPositiveInteger|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::anySimpleType;
our @ISA = qw(Corinna::Builtin::SimpleType);

Corinna::Builtin::anySimpleType->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::anySimpleType',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'anySimpleType|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::anyURI;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::anyURI->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::anyURI',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'anyURI|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::byte;
our @ISA = qw(Corinna::Builtin::integer);

Corinna::Builtin::byte->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::byte',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 127,
            'minInclusive' => -128,
            'name'         => 'byte|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::decimal;
our @ISA = qw(Corinna::Builtin::Numeric);

Corinna::Builtin::decimal->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::decimal',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'decimal|http://www.w3.org/2001/XMLSchema',
            'regex'       => qr/^[+-]?\d+(?:\.\d+)?$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::double;
our @ISA = qw(Corinna::Builtin::Numeric);

Corinna::Builtin::double->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::double',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'double|http://www.w3.org/2001/XMLSchema',

            # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
            'regex' =>
              qr/^[+-]?(?:(?:INF)|(?:NaN)|(?:\d+(?:\.\d+)?)(?:[eE][+-]?\d+)?)$/,
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::duration;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::duration->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::duration',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'duration|http://www.w3.org/2001/XMLSchema',

# Regex shamelessly copied from XML::Validator::Schema by Sam Tregar who thanks to perlmonk Abigail-II
            'regex' => qr /^-? 				  # Optional leading minus.
					            P                     # Required.
					            (?=[T\d])             # Duration cannot be empty.
						        (?:(?!-) \d+ Y)?      # Non-negative integer, Y (optional)
           						(?:(?!-) \d+ M)?      # Non-negative integer, M (optional)
           						(?:(?!-) \d+ D)?      # Non-negative integer, D (optional)
								(
           						(?:T (?=\d)           # T, must be followed by a digit.
           						(?:(?!-) \d+ H)?      # Non-negative integer, H (optional)
           						(?:(?!-) \d+ M)?      # Non-negative integer, M (optional)
           						(?:(?!-) \d+\.\d+ S)? # Non-negative decimal, S (optional)
           						)?                    # Entire T part is optional
								)$/x,
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::ENTITIES;
our @ISA = qw(Corinna::Builtin::List);

Corinna::Builtin::ENTITIES->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::ENTITIES',
            'contentType' => 'simple',
            'derivedBy'   => 'list',
            'name'        => 'ENTITIES|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::ENTITY;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::ENTITY->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::ENTITY',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'ENTITY|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::float;
our @ISA = qw(Corinna::Builtin::Numeric);

Corinna::Builtin::float->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::float',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'float|http://www.w3.org/2001/XMLSchema',
            'regex' =>
              qr/^[+-]?(?:(?:INF)|(?:NaN)|(?:\d+(?:\.\d+)?)(?:[eE][+-]?\d+)?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::gDay;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::gDay->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::gDay',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'gDay|http://www.w3.org/2001/XMLSchema',
            'regex' =>
qr /^---([0-2]\d{1}|3[0|1])(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::gMonth;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::gMonth->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::gMonth',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'gMonth|http://www.w3.org/2001/XMLSchema',
            'regex' =>
              qr /^--(0\d|1[0-2])(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::gMonthDay;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::gMonthDay->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::gMonthDay',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'gMonthDay|http://www.w3.org/2001/XMLSchema',
            'regex' =>
              qr /^--(\d{2,})-(\d\d)(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::gYear;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::gYear->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::gYear',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'gYear|http://www.w3.org/2001/XMLSchema',
            'regex' =>
              qr /^[-]?(\d{4,})(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::gYearMonth;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::gYearMonth->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::gYearMonth',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'gYearMonth|http://www.w3.org/2001/XMLSchema',
            'regex' =>
qr /^[-]?(\d{4,})-(1[0-2]{1}|0\d{1})(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::ID;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::ID->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::ID',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'ID|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::IDREF;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::IDREF->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::IDREF',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'IDREF|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::IDREFS;
our @ISA = qw(Corinna::Builtin::List);

Corinna::Builtin::IDREFS->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::IDREFS',
            'contentType' => 'simple',
            'derivedBy'   => 'list',
            'name'        => 'IDREFS|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::int;
our @ISA = qw(Corinna::Builtin::integer);

Corinna::Builtin::int->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::int',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 2147483647,
            'minInclusive' => -2147483648,
            'name'         => 'int|http://www.w3.org/2001/XMLSchema',
            'regex'        => qr/^[+-]?\d+$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::language;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::language->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::language',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'language|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::long;
our @ISA = qw(Corinna::Builtin::integer);

Corinna::Builtin::long->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::long',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'long|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::Name;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::Name->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::Name',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'Name|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::NCName;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::NCName->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::NCName',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'NCName|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::negativeInteger;
our @ISA = qw(Corinna::Builtin::nonPositiveInteger);

Corinna::Builtin::negativeInteger->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::negativeInteger',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => -1,
            'name' => 'negativeInteger|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::NMTOKEN;
our @ISA = qw(Corinna::Builtin::token);

Corinna::Builtin::NMTOKEN->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::NMTOKEN',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'NMTOKEN|http://www.w3.org/2001/XMLSchema',
            'regex'       => qr/^[-.:\w\d]*$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::NMTOKENS;
our @ISA = qw(Corinna::Builtin::List);

Corinna::Builtin::NMTOKENS->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::NMTOKENS',
            'contentType' => 'simple',
            'derivedBy'   => 'list',
            'name'        => 'NMTOKENS|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::normalizedString;
our @ISA = qw(Corinna::Builtin::string);

Corinna::Builtin::normalizedString->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::normalizedString',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'       => 'normalizedString|http://www.w3.org/2001/XMLSchema',
            'whiteSpace' => 'replace',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::NOTATION;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::NOTATION->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::NOTATION',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'NOTATION|http://www.w3.org/2001/XMLSchema',
            'regex'       => qr /^([A-z][A-z0-9]+:)?([A-z][A-z0-9]+)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::positiveInteger;
our @ISA = qw(Corinna::Builtin::nonNegativeInteger);

Corinna::Builtin::positiveInteger->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::positiveInteger',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'minInclusive' => 1,
            'name' => 'positiveInteger|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::QName;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::QName->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::QName',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'QName|http://www.w3.org/2001/XMLSchema',
            'regex'       => qr /^([A-z][A-z0-9]+:)?([A-z][A-z0-9]+)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::short;
our @ISA = qw(Corinna::Builtin::integer);

Corinna::Builtin::short->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::short',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 32767,
            'minInclusive' => -32768,
            'name'         => 'short|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::time;
our @ISA = qw(Corinna::Builtin::Scalar);

Corinna::Builtin::time->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::time',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'time|http://www.w3.org/2001/XMLSchema',
            'regex' =>
qr /^[0-2]\d:[0-5]\d:[0-5]\d(\.\d+)?(Z?|([+|-]([0-1]\d|2[0-4])\:([0-5]\d))?)$/
            , # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::unsignedByte;
our @ISA = qw(Corinna::Builtin::nonNegativeInteger);

Corinna::Builtin::unsignedByte->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::unsignedByte',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 255,
            'minInclusive' => 0,
            'name'         => 'unsignedByte|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::unsignedInt;
our @ISA = qw(Corinna::Builtin::nonNegativeInteger);

Corinna::Builtin::unsignedInt->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::unsignedInt',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 4294967295,
            'minInclusive' => 0,
            'name'         => 'unsignedInt|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::unsignedLong;
our @ISA = qw(Corinna::Builtin::nonNegativeInteger);

Corinna::Builtin::unsignedLong->XmlSchemaType(
    bless(
        {
            'class'       => 'Corinna::Builtin::unsignedLong',
            'contentType' => 'simple',
            'derivedBy'   => 'restriction',
            'name'        => 'unsignedLong|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

#======================================================================
package Corinna::Builtin::unsignedShort;
our @ISA = qw(Corinna::Builtin::nonNegativeInteger);

Corinna::Builtin::unsignedShort->XmlSchemaType(
    bless(
        {
            'class'        => 'Corinna::Builtin::unsignedShort',
            'contentType'  => 'simple',
            'derivedBy'    => 'restriction',
            'maxInclusive' => 65535,
            'minInclusive' => 0,
            'name'         => 'unsignedShort|http://www.w3.org/2001/XMLSchema',
        },
        'Corinna::Schema::SimpleType'
    )
);

1;

__END__

=head1 NAME

B<Corinna::Builtin> - Module that includes definitions of all L<Corinna> B<W3C builtin> type classes .

=head1 WARNING

This module is used internally by L<Corinna>. You do not normally know much about this module to actually use L<Corinna>.  It is 
documented here for completeness and for L<Corinna> developers. Do not count on the interface of this module. It may change in 
any of the subsequent releases. You have been warned. 

=head1 SYNOPSIS

  use Corinna::Builtin;

=head1 DESCRIPTION

B<Corinna::Builtin> is a module that includes the definitions of the classes that represent 
the W3C B<builtin> simple types. These builtin packages are either directly defined here in this
module or otherwise they are I<use>d by this module so that you don't have to I<use> them in 
your program once you I<use> this module. 

Each builtin type corresponds to a package. So this module defines multiple packages at once. 
In each of the packages, the B<XmlSchemaType> class data accessor is set with an object of
type L<Corinna::Schema::SimpleType>. This object contains the W3C facets that are used during xml validation,
such as pattern, minInclusive, and so on. An internal I<facet> called I<regex> (not defined by W3C) is used to give
the regex patterns that correspond to the B<builtin> types. The I<regex> facet will be guaranteed to be a Perl regex
while the I<pattern> facet (W3C) may divert from Perl regular expressions although they seem identical to me at this time.

All B<builtin> classes descend from L<Corinna::Builtin::SimpleType> which itself descends from
L<Corinna::SimpleType>.

There exist some ancestors for groupings of B<builtin> types. For example, all numeric builtin types descend directly or
indirecly from L<Corinna::Builtin::Numeric>. 

Such groupings are listed below:

=over

=item * L<Corinna::Builtin::List> : List types such as B<NMTOKENS>

=item * L<Corinna::Builtin::Numeric> : Numeric types such as B<integer>

=item * L<Corinna::Builtin::Scalar> : All scalar and numeric types including such as B<string>

=item * L<Corinna::Builtin::Union> : Union types

=back


=head1 EXAMPLE

Below is an example of how the B<double> type is defined in the B<Corinna::Builtin::double> package.

  package Corinna::Builtin::double;
  our @ISA = qw(Corinna::Builtin::Numeric);

  Corinna::Builtin::double->XmlSchemaType( bless( {
                'class' => 'Corinna::Builtin::double',
                'contentType' => 'simple',
                 'derivedBy' => 'restriction',
                 'name' => 'double|http://www.w3.org/2001/XMLSchema',
                 
                 # Regex shamelessly copied from XML::Validator::Schema by Sam Tregar                 
                 'regex' => qr/^[+-]?(?:(?:INF)|(?:NaN)|(?:\d+(?:\.\d+)?)(?:[eE][+-]?\d+)?)$/,
               }, 'Corinna::Schema::SimpleType' ) );



=head1 BUILTIN TYPES

Below is a list of W3C B<builtin> types defined either directly in this module, or I<use>d by it (and so
made available through it). 

=over

=item * B<anySimpleType> defined here in package Corinna::Builtin::anySimpleType;

=item * B<anyURI> defined here in package Corinna::Builtin::anyURI;

=item * B<base64Binary> defined in L<Corinna::Builtin::base64Binary>

=item * B<boolean> defined in L<Corinna::Builtin::boolean>

=item * B<byte> defined here in package Corinna::Builtin::byte;

=item * B<date> defined in L<Corinna::Builtin::date>

=item * B<dateTime> defined in L<Corinna::Builtin::dateTime>

=item * B<decimal> defined here in package Corinna::Builtin::decimal;

=item * B<double> defined here in package Corinna::Builtin::double;

=item * B<duration> defined here in package Corinna::Builtin::duration;

=item * B<ENTITIES> defined here in package Corinna::Builtin::ENTITIES;

=item * B<ENTITY> defined here in package Corinna::Builtin::ENTITY;

=item * B<float> defined here in package Corinna::Builtin::float;

=item * B<gDay> defined here in package Corinna::Builtin::gDay;

=item * B<gMonth> defined here in package Corinna::Builtin::gMonth;

=item * B<gMonthDay> defined here in package Corinna::Builtin::gMonthDay;

=item * B<gYear> defined here in package Corinna::Builtin::gYear;

=item * B<gYearMonth> defined here in package Corinna::Builtin::gYearMonth;

=item * B<hexBinary> defined in L<Corinna::Builtin::hexBinary>

=item * B<ID> defined here in package Corinna::Builtin::ID;

=item * B<IDREF> defined here in package Corinna::Builtin::IDREF;

=item * B<IDREFS> defined here in package Corinna::Builtin::IDREFS;

=item * B<int> defined here in package Corinna::Builtin::int;

=item * B<integer> defined here in package Corinna::Builtin::integer;

=item * B<language> defined here in package Corinna::Builtin::language;

=item * B<long> defined here in package Corinna::Builtin::long;

=item * B<Name> defined here in package Corinna::Builtin::Name;

=item * B<NCName> defined here in package Corinna::Builtin::NCName;

=item * B<negativeInteger> defined here in package Corinna::Builtin::negativeInteger;

=item * B<NMTOKEN> defined here in package Corinna::Builtin::NMTOKEN;

=item * B<NMTOKENS> defined here in package Corinna::Builtin::NMTOKENS;

=item * B<nonNegativeInteger> defined here in package Corinna::Builtin::nonNegativeInteger;

=item * B<nonPositiveInteger> defined here in package Corinna::Builtin::nonPositiveInteger;

=item * B<normalizedString> defined here in package Corinna::Builtin::normalizedString;

=item * B<NOTATION> defined here in package Corinna::Builtin::NOTATION;

=item * B<positiveInteger> defined here in package Corinna::Builtin::positiveInteger;

=item * B<QName> defined here in package Corinna::Builtin::QName;

=item * B<short> defined here in package Corinna::Builtin::short;

=item * B<string> defined here in package Corinna::Builtin::string;

=item * B<time> defined here in package Corinna::Builtin::time;

=item * B<token> defined here in package Corinna::Builtin::token;

=item * B<unsignedByte> defined here in package Corinna::Builtin::unsignedByte;

=item * B<unsignedInt> defined here in package Corinna::Builtin::unsignedInt;

=item * B<unsignedLong> defined here in package Corinna::Builtin::unsignedLong;

=item * B<unsignedShort> defined here in package Corinna::Builtin::unsignedShort;


=back




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
