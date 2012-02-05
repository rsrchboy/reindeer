package Reindeer::Role;

# ABSTRACT: Reindeer in role form

use strict;
use warnings;

use Reindeer::Util;
use Moose::Exporter;

my (undef, undef, $init_meta) = Moose::Exporter->build_import_methods(
    install => [ qw{ import unimport } ],

    also          => [ 'Moose::Role', Reindeer::Util::also_list() ],
    trait_aliases => [ Reindeer::Util::trait_aliases()            ],
    as_is         => [ Reindeer::Util::as_is()                    ],
);

sub init_meta {
    my ($class, %options) = @_;
    my $for_class = $options{for_class};

    ### $for_class
    Moose::Role->init_meta(for_class => $for_class);
    Reindeer::Util->import_type_libraries({ -into => $for_class });
    Path::Class->export_to_level(1);
    Try::Tiny->export_to_level(1);
    MooseX::MarkAsMethods->import({ into => $for_class }, autoclean => 1);

    goto $init_meta if defined $init_meta;
}

!!42;

__END__

=begin Pod::Coverage

    init_meta

=end Pod::Coverage

=head1 SYNOPSIS

    # ta-da!
    use Reindeer::Role;

=head1 DESCRIPTION

For now, see the L<Reindeer> docs for information about what meta extensions
are automatically applied.

=head1 SEE ALSO

L<Moose::Role>

=cut
