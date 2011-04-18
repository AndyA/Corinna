use 5.008;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Corinna',
    license           => 'perl',
    dist_author       => q{Curtis 'Ovid' Poe <ovid@cpan.org>},
    dist_version_from => 'lib/Corinna.pm',
    build_requires    => { 'Test::Most' => 0.23, },
    requires          => {
        'perl'                   => 5.008,
        'Carp'                     => 0,
        'Class::Accessor'          => 0,
        'Class::Data::Inheritable' => 0,
        'Cwd'                      => 0,
        'Data::Dumper'             => 0,
        'Data::HashArray'          => 0,
        'File::Path'               => 0,
        'File::Spec'               => 0,
        'File::chdir'              => 0,
        'Getopt::Long'             => 0,
        'IO::File'                 => 0,
        'LWP::UserAgent'           => 0,
        'MIME::Base64'             => 0,
        'Moose'                    => 1,
        'MooseX::UndefTolerant'    => 0.12,
        'Pod::Usage'               => 0,
        'Scalar::Util'             => 0,
        'Test::More'               => 0,
        'URI'                      => 0,
        'XML::LibXML'              => '1.66',    # Unicode problems before
    },
    add_to_cleanup     => ['Corinna-*'],
    create_makefile_pl => 'traditional',
    meta_merge =>
      { resources => { repository => 'https://github.com/Ovid/Corinna' } },
);

$builder->create_build_script();
