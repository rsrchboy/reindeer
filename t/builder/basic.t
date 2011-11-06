#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose;

use Moose::Util 'does_role';

# This is more of a "spot check" than an actual set of tests

{
    package TestClass::Reindeer;

    use strict;
    use warnings;

    use Reindeer::Builder
        also => {
            exclude => [ 'MooseX::StrictConstructor' ],
        },
        ;

}
BEGIN { $INC{'TestClass/Reindeer.pm'} = 1 }
{
    package TestClass::Class;

    use TestClass::Reindeer;

    has foo => (is => 'rw');
}

with_immutable {
    meta_ok 'TestClass::Class';
    ok !does_role('TestClass::Class', 'MooseX::StrictConstructor::Trait::Class'),
        'TestClass::Class does not do the excluded trait';
    has_attribute_ok 'TestClass::Class', 'foo';
} 'TestClass::Class';

done_testing;
