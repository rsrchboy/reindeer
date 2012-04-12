#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More 0.007;

# XXX This is more of a "spot check" than an actual set of tests

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

    validate_class 'TestClass::Class' => (
        attributes => [ qw{ foo } ],
        does_not   => [ qw{ MooseX::StrictConstructor::Trait::Class } ],
    );

} 'TestClass::Class';

done_testing;
