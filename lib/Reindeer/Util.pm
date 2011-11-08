package Reindeer::Util;

# ABSTRACT: Common and utility functions for Reindeer

use strict;
use warnings;

use Class::Load 'load_class';

use Moose                                   ( );
use MooseX::AlwaysCoerce                    ( );
use MooseX::AbstractMethod                  ( );
use MooseX::AttributeShortcuts 0.006        ( );
use MooseX::LazyRequire 0.07                ( );
use MooseX::MarkAsMethods 0.14              ( );
use MooseX::NewDefaults                     ( );
use MooseX::StrictConstructor               ( );
use MooseX::Types::Moose                    ( );
use MooseX::Types::Common::String           ( );
use MooseX::Types::Common::Numeric          ( );
use MooseX::Types::Path::Class              ( );
use MooseX::Types::Tied::Hash::IxHash 0.002 ( );

# SetOnce, AutoDestruct, MultiInitArg, ClassAttribute
# SlurpyConstructor, Params::Validate

sub trait_aliases {

    # note that merely specifing aliases does not load the packages; Moose
    # will handle that when (if) the trait is ever used.
    return (
        [ 'MooseX::AutoDestruct::Trait::Attribute'           => 'AutoDestruct'  ],
        [ 'MooseX::MultiInitArg::Trait'                      => 'MultiInitArg'  ],
        [ 'MooseX::TrackDirty::Attributes::Trait::Attribute' => 'TrackDirty'    ],
        [ 'MooseX::UndefTolerant::Attribute'                 => 'UndefTolerant' ],

        # LazyRequire doesn't export a trait_alias, so let's create one
        'MooseX::LazyRequire::Meta::Attribute::Trait::LazyRequire',

        # this one is a little funky, in that it replaces the accessor
        # metaclass, rather than just applying a trait to it
        [ 'Moose::Meta::Attribute::Custom::Trait::MergeHashRef' => 'MergeHashRef' ],
    );
}

# If an extension doesn't have a trait that's directly loadable, we build subs
# to do it here.

sub SetOnce { _lazy('MooseX::SetOnce', 'MooseX::SetOnce::Attribute') }
sub _lazy { load_class(shift); shift }

sub as_is {

    return (
        \&SetOnce,
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
        MooseX::LazyRequire
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
        MooseX::Types::Path::Class
        MooseX::Types::Tied::Hash::IxHash
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
