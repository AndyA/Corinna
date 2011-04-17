use utf8;
use strict;
use warnings;

#=======================================================
package Corinna::Schema;

use Corinna::Schema::Attribute;
use Corinna::Schema::AttributeGroup;
use Corinna::Schema::ComplexType;
use Corinna::Schema::Context;
use Corinna::Schema::Documentation;
use Corinna::Schema::Element;
use Corinna::Schema::Group;
use Corinna::Schema::List;
use Corinna::Schema::Model;
use Corinna::Schema::NamespaceInfo;
use Corinna::Schema::Object;
use Corinna::Schema::Parser;
use Corinna::Schema::SimpleType;
use Corinna::Schema::Union;

our @ISA = qw(Corinna::Schema::Object);

Corinna::Schema->mk_accessors(
qw(	targetNamespace 	 	 
	attributeFormDefault 	elementFormDefault));

1;
