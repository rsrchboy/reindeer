#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More 0.009;

use Test::Requires {
    'MooseX::Attribute::ENV' => '0.02',
};

# Validate that the trait is applied

{ package TestClass;          use Reindeer;       has one => (traits => [ENV], is => 'ro'); }
{ package TestClass::Role;    use Reindeer::Role; has one => (traits => [ENV], is => 'ro'); }
{ package TestClass::Compose; use Reindeer;       with 'TestClass::Role';                   }

for my $class (qw{ TestClass TestClass::Compose }) {

    with_immutable {
        validate_class $class => (
            attributes => [ one => { does => [ 'MooseX::Attribute::ENV' ] } ],
        );
    } $class;
}

done_testing;
