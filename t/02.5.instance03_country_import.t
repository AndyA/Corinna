use utf8;
use Test::More tests => 103;

use Scalar::Util qw(refaddr);

use_ok('URI');
use_ok('URI::file');
use_ok('Corinna');

binmode( STDOUT, ":utf8" );
binmode( STDERR, ":utf8" );

my $pastor = Corinna->new();

$pastor->generate(
    mode         => 'eval',
    schema       => ['./test/source/country/schema/country_schema4_import.xsd'],
    class_prefix => "Corinna::Test",
    destination  => './test/out/lib/',
    verbose      => 0
);

# ======= COUNTRY ==============
my $country_in =
  Corinna::Test::country->from_xml(
    URI::file->new_abs('./test/source/country/xml/country_import.xml') );

$country_in->to_xml_file('./test/out/country_import.xml');
my $country_out =
  Corinna::Test::country->from_xml_file('./test/out/country_import.xml');

$country_in->to_xml_file( './test/out/country_import_latin1.xml',
    encoding => 'iso-8859-1' );
my $country_latin1 =
  Corinna::Test::country->from_xml_file('./test/out/country_import_latin1.xml');

my @countries = ( $country_in, $country_out, $country_latin1 );

foreach my $country (@countries) {
    my $pass = ' [UNKOWN] ';

  SWITCH: {
        ( refaddr($country) == refaddr($country_in) )
          and do { $pass = ' [IN] '; last SWITCH; };
        ( refaddr($country) == refaddr($country_out) )
          and do { $pass = ' [OUT-UTF8] '; last SWITCH; };
        ( refaddr($country) == refaddr($country_latin1) )
          and do { $pass = ' [OUT-LATIN1] '; last SWITCH; };
    }

    ok( defined($country), "defined country $pass" );

    my @ancestors = qw( Corinna::Type
      Corinna::ComplexType
      Corinna::Element
      Corinna::Test::country
    );

    foreach my $ancestor (@ancestors) {
        isa_ok( $country, $ancestor, "country $pass" );
    }

    # Corinna::Type methods
    can_ok(
        $country,
        qw(
          new
          is_xml_valid
          xml_validate
          xml_validate_futher
          )
    );

    # Corinna::Type class methods
    can_ok(
        $country,
        qw(
          XmlSchemaType
          )
    );

    # Corinna::ComplexType methods
    can_ok(
        $country,
        qw( 	xml_field_class
          is_xml_field_singleton
          is_xml_field_multiple
          get
          set
          grab
          from_xml_dom
          from_xml
          from_xml_file
          from_xml_fh
          from_xml_fragment
          from_xml_string
          from_xml_url
          to_xml
          to_xml_dom
          to_xml_dom_document)
    );

    # Corinna::Element class methods
    can_ok(
        $country,
        qw(
          XmlSchemaElement
          )
    );

    # Field accessor methods
    can_ok(
        $country,
        qw(
          code
          name
          city
          currency
          population
          )
    );

    # ======= COUNTRY CODE =========
    my $country_code = $country->code;

    ok( defined($country_code), "defined country code $pass" );

    # ISA tests
    @ancestors = qw( 	Corinna::Type
      Corinna::SimpleType
    );

    foreach my $ancestor (@ancestors) {
        isa_ok( $country_code, $ancestor, "country code $pass" );
    }

    # Corinna::Type methods
    can_ok(
        $country_code,
        qw(
          new
          is_xml_valid
          xml_validate
          xml_validate_futher
          )
    );

    # Corinna::Type class methods
    can_ok(
        $country_code,
        qw(
          XmlSchemaType
          )
    );

    # Corinna::SimpleType methods
    can_ok(
        $country_code,
        qw( 	from_xml_dom
          xml_validate
          xml_validate_further
          normalize_whitespace
          )
    );

    # Accessor methods
    can_ok(
        $country_code,
        qw(
          __value
          )
    );

    # ===== EXPECTED VALUES =========
    my $expected;

    # Check the country code
    $expected = 'fr';
    is( lc( $country->code ), lc($expected), "country code $pass" );

    # Check the country name
    $expected = 'france';
    is( lc( $country->name ), lc($expected), "country name $pass" );

    # Check the country name language
    $expected = 'en';
    is( lc( $country->name->_lang ),
        lc($expected), "country name language $pass" );

    my $language = $country->language;
    is( $language->code2, 'fr',     "country language code" );
    is( $language->name,  'French', "country language name" );

    # Defined city
    my $cities = $country->city;
    ok( defined($cities), "defined cities $pass" );

    # Get a hash of the cities on 'code' attribute
    my $city_h = $cities->hash( sub { shift->code() } );
    my $code;
    my $city;

    # Check the name of a given city
    $code = 'AVA';
    $city = $city_h->{$code};
    ok( defined($city), "City exists {$code}" );
    $expected = 'Ambrières-les-Vallées';
    is( lc( $city->name ), lc($expected),
        "$pass => city name '" . $code . "'" );

    # Check the name of a given city
    $code = 'BCX';
    $city = $city_h->{$code};
    ok( defined($city), "$pass => City exists {$code}" );
    $expected = 'Beire-le-Châtel';
    is( lc( $city->name ), lc($expected),
        "$pass => city name '" . $code . "'" );

    # Check the name of a given city
    $code = 'LYO';
    $city = $city_h->{$code};
    ok( defined($city), "$pass => City exists {$code}" );
    $expected = 'Lyon';
    is( lc( $city->name ), lc($expected), "city name '" . $code . "'" );

    # Check the name of a given city
    $code = 'NCE';
    $city = $city_h->{$code};
    ok( defined($city), "$pass => City exists {$code}" );
    $expected = 'Nice';
    is( lc( $city->name ), lc($expected),
        "$pass => city name '" . $code . "'" );

    # Check the name of a given city
    $code = 'PAR';
    $city = $city_h->{$code};
    ok( defined($city), "$pass => City exists {$code}" );
    $expected = 'Paris';
    is( lc( $city->name ), lc($expected),
        "$pass => city name '" . $code . "'" );

}    # foreach $country

#	print STDERR "\nTest OVER baby!\n";
ok( 1, 'end' );    # survived everything

1;

