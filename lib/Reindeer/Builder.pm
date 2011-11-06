package Reindeer::Builder;

# ABSTRACT: Easily build a new 'Reindeer' style class

use strict;
use warnings;

use Carp;
use Moose::Exporter;
use Sub::Install;

use Reindeer ();
use Reindeer::Util;

# Look at our args, figure out what needs to be added/filtered

sub import {
    my ($class, %config) = @_;

    # figure out if we're supposed to be for a role
    my $target = caller(0); # let's start out simple
    my $for_role = ($target =~ /::Role$/) ? 1 : 0;

    my @also;
    if (exists $config{also}) {

        my $also_config = $config{also};

        my @reindeer = Reindeer::Util::also_list();
        my @exclude  = @{ $config{also}->{exclude} || [] };
        my @add      = @{ $config{also}->{add}     || [] };

        @also = @reindeer;

        do { @also = grep { ! $_ ~~ [ @exclude ] } @also }
            if @exclude > 0;

        do { push @also, @add } if @add > 0;
    }

    unshift @also, ($for_role ? 'Moose::Role' : 'Moose');

    # create our methods...
    #my ($import, $unimport, $init_meta) = Moose::Exporter->build_import_methods(
    my %methods;
    @methods{qw/ import unimport init_meta /} =
        Moose::Exporter->build_import_methods(
            also => [ @also ],
        );

    my $_install = sub {
        Sub::Install::reinstall_sub({
            code => $methods{$_[0]},
            into => $target,
            as   => $_[0],
        });
    };

    do { $_install->($_) if defined $methods{$_} }
        for keys %methods;

    return;
}

!!42;

__END__

=head1 SYNOPSIS

    use Reindeer::Builder
        also => {
            exclude => [ ... ], # packages from also
            add     => [ ... ],
        };

