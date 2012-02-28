package Reindeer::Types;

# ABSTRACT: Reindeer combined type library

use strict;
use warnings;

use base 'MooseX::Types::Combine';

use Reindeer::Util;

# no provision for filtering
__PACKAGE__->provide_types_from(Reindeer::Util::type_libraries());

!!42;

__END__

=head1 SYNOPSIS

    package Foo;
    use Moose;
    use Reindeer::Types ':all';

=head1 DESCRIPTION

This is a combined type library, allowing for the quick and easy import of all
the type libraries L<Reindeer> provides by default.  Its primary goal is to
make the types easily available even when using Reindeer isn't an option.

It is not necessary (or prudent) to directly use this in a Reindeer class (or
role).

=head1 TYPES

=from_other MooseX::Types::LoadableClass / TYPES EXPORTED / type

=from_other MooseX::Types::Common::String / DESCRIPTION / type

=from_other MooseX::Types::Common::Numeric / DESCRIPTION / type

=from_other MooseX::Types::Tied::Hash::IxHash / TYPES / all

(See also L<MooseX::Types::Tied::Hash::IxHash>.)

=head2 Dir

    has 'dir' => (
        is       => 'ro',
        isa      => Dir,
        required => 1,
        coerce   => 1,
    );

(See also L<MooseX::Types::Path::Class>.)

=head2 File

    has 'file' => (
        is       => 'ro',
        isa      => File,
        required => 1,
        coerce   => 1,
    );

(See also L<MooseX::Types::Path::Class>.)

=head2 MooseX::Types::Moose

We provide all Moose native types by including L<MooseX::Types::Moose>; see
that package for more information.

=head1 SEE ALSO

L<Reindeer> has the full list of type libraries we incorporate.
L<MooseX::Types::Combine>.

=cut
