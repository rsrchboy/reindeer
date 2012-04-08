#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose::More 0.006;

# This is more of a "spot check" than an actual set of tests

{ package TestClass; use Reindeer; }

with_immutable {

    validate_class TestClass => (
        does       => [ qw{ MooseX::Traits   } ],
        attributes => [ qw{ _trait_namespace } ],
    );

} 'TestClass';

done_testing;
