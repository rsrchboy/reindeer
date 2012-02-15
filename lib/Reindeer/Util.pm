package Reindeer::Util;

# ABSTRACT: Common and utility functions for Reindeer

use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [ qw{ trait_aliases as_is also_list type_libraries } ],
};

use Class::Load 'load_class';

use Moose 1.15                              ( );
use MooseX::AlwaysCoerce 0.16               ( );
use MooseX::AbstractMethod 0.003            ( );
use MooseX::AttributeShortcuts 0.006        ( );
use MooseX::ClassAttribute 0.26             ( );
use MooseX::LazyRequire 0.07                ( );
use MooseX::MarkAsMethods 0.14              ( );
use MooseX::NewDefaults 0.003               ( );
use MooseX::StrictConstructor 0.19          ( );
use MooseX::Types::Moose 0.31               ( );
use MooseX::Types::Common::String 0.001004  ( );
use MooseX::Types::Common::Numeric 0.001004 ( );
use MooseX::Types::LoadableClass 0.006      ( );
use MooseX::Types::Path::Class 0.05         ( );
use MooseX::Types::Tied::Hash::IxHash 0.002 ( );

use Path::Class 0.24 ( );
use Try::Tiny 0.11   ( );

# SlurpyConstructor, Params::Validate

=func trait_aliases

Trait alias definitions for our optional traits.

=cut

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

=func as_is

A list of sugar to export "as_is".

=cut

sub as_is {

    return (
        \&SetOnce,
    );
}

# Types:
# Tied, Perl, IxHash, ENV

# Roles:
# TraitConstructor, Traits

=func also_list

A list of Moose::Exporter based packages that we should also invoke (through
Moose::Exporter, that is).

=cut

sub also_list {

    return qw{
        MooseX::AbstractMethod
        MooseX::AlwaysCoerce
        MooseX::AttributeShortcuts
        MooseX::ClassAttribute
        MooseX::LazyRequire
        MooseX::NewDefaults
        MooseX::StrictConstructor
    };
}

=func import_type_libraries

Import our list of type libraries into a given package.

=cut

sub import_type_libraries {
    my ($class, $opts) = @_;

    #$_->import({ -into => $opts->{for_class} }, ':all')
    $_->import($opts, ':all')
        for type_libraries();

    return;
}

=func type_libraries

Returns a list of type libraries currently exported by Reindeer.

=cut

sub type_libraries {

    return qw{
        MooseX::Types::Moose
        MooseX::Types::Common::String
        MooseX::Types::Common::Numeric
        MooseX::Types::LoadableClass
        MooseX::Types::Path::Class
        MooseX::Types::Tied::Hash::IxHash
    };
}

!!42;

__END__

=begin Pod::Coverage

    SetOnce

=end Pod::Coverage

=head1 SYNOPSIS

=head1 DESCRIPTION

This package provides the parts of Reindeer that are common to both Reindeer
and Reindeer role.  In general, this package contains functions that either
return lists for L<Moose::Exporter> or actively import other packages into the
namespace of packages invoking Reindeer or Reindeer::Role (e.g. type
libraries).

=cut
