#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More 0.005;

# This is more of a "spot check" than an actual set of tests

{
    package TestClass;
    use Reindeer;

    has oneA => (is => 'ro');
    has oneB => (is => 'ro', isa => Str);

    has oneC => (is => 'lazy');
    has oneD => (is => 'rw', isa => NonEmptySimpleStr);

    my $i;
    $i++;
}
{
    package TestClass::Role;
    use Reindeer::Role;

    has two => (is => 'ro');
}

# make sure classes behave as we expect
with_immutable {
    does_ok(TestClass->meta, 'MooseX::MarkAsMethods::MetaRole::MethodMarker');
    check_sugar_removed_ok('TestClass');
} qw{ TestClass };

# make sure roles behave as we expect
does_ok(TestClass->meta, 'MooseX::MarkAsMethods::MetaRole::MethodMarker');
check_sugar_removed_ok('TestClass::Role');

done_testing;
