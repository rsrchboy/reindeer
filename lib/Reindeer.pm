package Reindeer;

# ABSTRACT: Moose with more antlers

use strict;
use warnings;

use Reindeer::Util;
use Moose::Exporter;

my (undef, undef, $init_meta) = Moose::Exporter->build_import_methods(
    install => [ qw{ import unimport }                ],
    also    => [ 'Moose', Reindeer::Util::also_list() ],
);

sub init_meta {
    my ($class, %options) = @_;
    my $for_class = $options{for_class};

    ### $for_class
    Moose->init_meta(for_class => $for_class);

    ### more properly in import()?
    Reindeer::Util->import_type_libraries({ -into => $for_class });
    Try::Tiny->export_to_level(1);
    MooseX::MarkAsMethods->import({ into => $for_class }, autoclean => 1);

    goto $init_meta if $init_meta;
}

!!42;

__END__

=head1 SYNOPSIS

    # ta-da!
    use Reindeer;

=head1 DESCRIPTION

Like L<Moose>?  Use MooseX::* extensions?  Maybe some L<MooseX::Types>
libraries?  Hate that you have to use them in every.  Single.  Class.

Reindeer aims to resolve that :)  Reindeer _is_ Moose -- it's just Moose with
a number of the more useful/popular extensions already applied.  Reindeer is a
drop-in replacement for your "use Moose" line, that behaves in the exact same
way... Just with more pointy antlers.

=head1 INCLUDED EXTENSIONS

Reindeer includes the traits and sugar provided by the following extensions.
Everything their docs say they can do, you can do by default with Reindeer.

=head2 L<MooseX::AbstractMethod>

=head2 L<MooseX::AlwaysCoerce>

=head2 L<MooseX::AttributeShortcuts>

=head2 L<MooseX::MarkAsMethods>

Note that this causes any overloads you've defined in your class/role to be
marked as methods, and L<namespace::autoclean> invoked.

=head2 L<MooseX::NewDefaults>

=head2 L<MooseX::StrictConstructor>

=head1 INCLUDED TYPE LIBRARIES

=head2 L<MooseX::Types::Moose>

=head2 L<MooseX::Types::Common::String>

=head2 L<MooseX::Types::Common::Numeric>

=head1 OTHER

Non-Moose specific items made available to your class/role:

=head2 L<Try::Tiny>

=head1 CAVEAT

This author is applying his own assessment of "useful/popular extensions".
You may find yourself in agreement, or violent disagreement with his choices.
YMMV :)

=head1 SEE ALSO

L<Moose>, L<Reindeer::Role>.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Bugs, feature requests and pull requests through GitHub are most welcome; our
page and repo (same URI):

    https://github.com/RsrchBoy/reindeer

=cut
