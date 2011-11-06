package Reindeer::Util;

# ABSTRACT: Common and utility functions for Reindeer

use strict;
use warnings;

use Moose                            ( );
use MooseX::AlwaysCoerce             ( );
use MooseX::AbstractMethod           ( );
use MooseX::AttributeShortcuts 0.006 ( );
use MooseX::NewDefaults              ( );
use MooseX::MarkAsMethods 0.14       ( );
use MooseX::StrictConstructor        ( );
use MooseX::Types::Moose             ( );
use MooseX::Types::Common::String    ( );
use MooseX::Types::Common::Numeric   ( );

# SetOnce, AutoDestruct, MultiInitArg, ClassAttribute
# SlurpyConstructor, Params::Validate

# Attribute traits (non-default):
# UndefTolerant, MergeHashRef

sub trait_aliases {

    return (
        [ 'MooseX::AutoDestruct::Trait::Attribute' => 'AutoDestruct'  ],
        [ 'MooseX::MultiInitArg::Trait'            => 'MultiInitArg'  ],
        [ 'MooseX::UndefTolerant::Attribute'       => 'UndefTolerant' ],
    );
}

# Types:
# Tied, Perl, IxHash, ENV

# Roles:
# TraitConstructor, Traits

sub also_list {

    return qw{
        MooseX::AbstractMethod
        MooseX::AlwaysCoerce
        MooseX::AttributeShortcuts
        MooseX::NewDefaults
        MooseX::StrictConstructor
    };
}

sub import_type_libraries {
    my ($class, $opts) = @_;

    #$_->import({ -into => $opts->{for_class} }, ':all')
    $_->import($opts, ':all')
        for type_libraries();

    return;
}

sub type_libraries {

    return qw{
        MooseX::Types::Moose
        MooseX::Types::Common::String
        MooseX::Types::Common::Numeric
    };
}

!!42;

__END__

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Bugs, feature requests and pull requests through GitHub are most welcome; our
page and repo (same URI):

    https://github.com/RsrchBoy/reindeer

=cut
