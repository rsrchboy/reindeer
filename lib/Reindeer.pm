package Reindeer;

# ABSTRACT: Moose with more antlers

use strict;
use warnings;

use Reindeer::Util;
use Moose::Exporter;
use Class::Load;

use MooseX::Traitor;
use Moose::Util::TypeConstraints ();

my (undef, undef, $init_meta) = Moose::Exporter->build_import_methods(
    install => [ qw{ import unimport } ],

    also          => [ 'Moose', Reindeer::Util::also_list() ],
    trait_aliases => [ Reindeer::Util::trait_aliases()      ],
    as_is         => [ Reindeer::Util::as_is()              ],

    base_class_roles => [ qw{ MooseX::Traitor } ],
);

sub init_meta {
    my ($class, %options) = @_;
    my $for_class = $options{for_class};

    if ($] >= 5.010) {

        eval 'use feature';
        feature->import(':5.10');
    }

    ### $for_class
    Moose->init_meta(for_class => $for_class);

    ### more properly in import()?
    Reindeer::Util->import_type_libraries({ -into => $for_class });
    Path::Class->export_to_level(1);
    Try::Tiny->export_to_level(1);
    MooseX::Params::Validate->import({ into => $for_class });
    Moose::Util::TypeConstraints->import(
        { into => $for_class },
        qw{ class_type role_type duck_type },
    );
    MooseX::MarkAsMethods->import({ into => $for_class }, autoclean => 1);

    goto $init_meta if $init_meta;
}

!!42;

__END__

=begin stopwords

AutoDestruct
MultiInitArg
UndefTolerant
autoclean
rwp
ttl
metaclass
Specifing

=end stopwords

=begin Pod::Coverage

    init_meta

=end Pod::Coverage

=head1 SYNOPSIS

    # ta-da!
    use Reindeer;

    # ...is the same as:
    use Moose;
    use MooseX::MarkAsMethods autoclean => 1;
    use MooseX::AlwaysCoerce;
    use MooseX::AttributeShortcuts;
    # etc, etc, etc

=head1 DESCRIPTION

Like L<Moose>?  Use MooseX::* extensions?  Maybe some L<MooseX::Types>
libraries?  Hate that you have to use them in every.  Single.  Class.

Reindeer aims to resolve that :)  Reindeer _is_ Moose -- it's just Moose with
a number of the more useful/popular extensions already applied.  Reindeer is a
drop-in replacement for your "use Moose" line, that behaves in the exact same
way... Just with more pointy antlers.

=head1 EARLY RELEASE!

Be aware this package should be considered early release code.  While L<Moose>
and all our incorporated extensions have their own classifications (generally
GA or "stable"), this bundling is still under active development, and more
extensions, features and the like may still be added.

That said, my goal here is to increase functionality, not decrease it.

When this package hits GA / stable, I'll set the release to be >= 1.000.

=head1 NEW CLASS METHODS

=head2 with_traits()

This method allows you to easily compose a new class with additional traits:

    my $foo = Bar->with_traits('Stools', 'Norm')->new(beer => 1, tab => undef);

(See also L<MooseX::Traits>.)

=head1 NEW ATTRIBUTE OPTIONS

Unless specified here, all options defined by Moose::Meta::Attribute
and Class::MOP::Attribute remain unchanged.

For the following, "$name" should be read as the attribute name; and the
various prefixes should be read using the defaults

=head2 coerce => 0

Coercion is ENABLED by default; explicitly pass "coerce => 0" to disable.

(See also L<MooseX::AlwaysCoerce>.)

=head2 lazy_require => 1

The reader methods for all attributes with that option will throw an exception
unless a value for the attributes was provided earlier by a constructor
parameter or through a writer method.

(See also L<MooseX::LazyRequire>.)

=from_other MooseX::AttributeShortcuts / NEW ATTRIBUTE OPTIONS / options

=head1 NEW KEYWORDS (SUGAR)

In addition to all sugar provided by L<Moose> (e.g. has, with, extends), we
provide a couple new keywords.

=head2 B<class_type ($class, ?$options)>

Creates a new subtype of C<Object> with the name C<$class> and the
metaclass L<Moose::Meta::TypeConstraint::Class>.

  # Create a type called 'Box' which tests for objects which ->isa('Box')
  class_type 'Box';

By default, the name of the type and the name of the class are the same, but
you can specify both separately.

  # Create a type called 'Box' which tests for objects which ->isa('ObjectLibrary::Box');
  class_type 'Box', { class => 'ObjectLibrary::Box' };

(See also L<Moose::Util::TypeConstraints>.)

=head2 B<role_type ($role, ?$options)>

Creates a C<Role> type constraint with the name C<$role> and the
metaclass L<Moose::Meta::TypeConstraint::Role>.

  # Create a type called 'Walks' which tests for objects which ->does('Walks')
  role_type 'Walks';

By default, the name of the type and the name of the role are the same, but
you can specify both separately.

  # Create a type called 'Walks' which tests for objects which ->does('MooseX::Role::Walks');
  role_type 'Walks', { role => 'MooseX::Role::Walks' };

(See also L<Moose::Util::TypeConstraints>.)

=head2 class_has => (...)

Exactly like L<Moose/has>, but operates at the class (rather than instance)
level.

(See also L<MooseX::ClassAttribute>.)

=from_other MooseX::NewDefaults / NEW SUGAR

=from_other MooseX::AbstractMethod / NEW SUGAR

=head1 OVERLOADS

It is safe to use overloads in your Reindeer classes and roles; they will
work just as you expect: overloads in classes can be inherited by subclasses;
overloads in roles will be incorporated into consuming classes.

(See also L<MooseX::MarkAsMethods>)

=head1 AVAILABLE OPTIONAL ATTRIBUTE TRAITS

We export the following trait aliases.  These traits are not
automatically applied to attributes, and are lazily loaded (e.g. if you don't
use them, they won't be loaded and are not dependencies).

They can be used by specifying them as:

    has foo => (traits => [ TraitAlias ], ...);

=head2 AutoDestruct

    has foo => (
        traits  => [ AutoDestruct ],
        is      => 'ro',
        lazy    => 1,
        builder => 1,
        ttl     => 600,
    );

Allows for a "ttl" attribute option; this is the length of time (in seconds)
that a stored value is allowed to live; after that time the value is cleared
and the value rebuilt (given that the attribute is lazy and has a builder
defined).

See L<MooseX::AutoDestruct> for more information.

=head2 CascadeClearing

This attribute trait allows one to designate that certain attributes are to be
cleared when certain other ones are; that is, when an attribute is cleared
that clearing will be cascaded down to other attributes.  This is most useful
when you have attributes that are lazily built.

See L<MooseX::CascadeClearing> for more information and a significantly more
cogent description.

=head2 ENV

This is a Moose attribute trait that you use when you want the default value
for an attribute to be populated from the %ENV hash.  So, for example if you
have set the environment variable USERNAME to 'John' you can do:

    package MyApp::MyClass;

    use Moose;
    use MooseX::Attribute::ENV;

    has 'username' => (is=>'ro', traits=>['ENV']);

    package main;

    my $myclass = MyApp::MyClass->new();

    print $myclass->username; # STDOUT => 'John';

This is basically similar functionality to something like:

    has 'attr' => (
            is=>'ro',
            default=> sub {
                    $ENV{uc 'attr'};
            },
    );

If the named key isn't found in %ENV, then defaults will execute as normal.

See L<MooseX::Attribute::ENV> for more information.

=head2 MultiInitArg

    has 'data' => (
        traits    => [ MultiInitArg ],
        is        => 'ro',
        isa       => 'Str',
        init_args => [qw(munge frobnicate)],
    );

This trait allows your attribute to be initialized with any one of multiple
arguments to new().

See L<MooseX::MultiInitArg> for more information.

=head2 UndefTolerant

Applying this trait to your attribute makes it's initialization tolerant of
of undef.  If you specify the value of undef to any of the attributes they
will not be initialized (or will be set to the default, if applicable).
Effectively behaving as if you had not provided a value at all.

    package My:Class;
    use Moose;

    use MooseX::UndefTolerant::Attribute;

    has 'bar' => (
        traits    => [ UndefTolerant ],
        is        => 'ro',
        isa       => 'Num',
        predicate => 'has_bar'
    );

    # Meanwhile, under the city...

    # Doesn't explode
    my $class = My::Class->new(bar => undef);
    $class->has_bar # False!

See L<MooseX::UndefTolerant::Attribute> for more information.

=head1 INCLUDED EXTENSIONS

Reindeer includes the traits and sugar provided by the following extensions.
Everything their docs say they can do, you can do by default with Reindeer.

=head2 L<MooseX::AbstractMethod>

=head2 L<MooseX::AlwaysCoerce>

=head2 L<MooseX::AttributeShortcuts>

=head2 L<MooseX::ClassAttribute>

=head2 L<MooseX::CurriedDelegation>

=head2 L<MooseX::LazyRequire>

=head2 L<MooseX::MarkAsMethods>

Note that this causes any overloads you've defined in your class/role to be
marked as methods, and L<namespace::autoclean> invoked.

=head2 L<MooseX::NewDefaults>

=head2 L<MooseX::StrictConstructor>

=head2 L<MooseX::Traits>

This provides a new class method, C<with_traits()>, allowing you to compose
traits in on the fly:

    my $foo = Bar->with_traits('Stools')->new(...);

=head1 INCLUDED TYPE LIBRARIES

=head2 L<MooseX::Types::Moose>

=head2 L<MooseX::Types::Common::String>

=head2 L<MooseX::Types::Common::Numeric>

=head2 L<MooseX::Types::LoadableClass>

=head2 L<MooseX::Types::Path::Class>

=head2 L<MooseX::Types::Tied::Hash::IxHash>

=head1 OTHER

Non-Moose specific items made available to your class/role:

=head2 Perl v5.10 features

If you're running on v5.10 or greater of Perl, Reindeer will automatically
enable v5.10 features in the consuming class.

=head2 L<namespace::autoclean>

Technically, this is done by L<MooseX::MarkAsMethods>, but it's worth pointing
out here.  Any overloads present in your class/role are marked as methods
before autoclean is unleashed, so Everything Will Just Work as Expected.

=head2 L<Path::Class>

=from_other Path::Class / SYNOPSIS / all

See the L<Path::Class> documentation for more detail.

=head2 L<Try::Tiny>

=from_other Try::Tiny / SYNOPSIS / all

See the L<Try::Tiny> documentation for more detail.

=head1 CAVEAT

This author is applying his own assessment of "useful/popular extensions".
You may find yourself in agreement, or violent disagreement with his choices.
YMMV :)

=head1 ACKNOWLEDGMENTS

Reindeer serves largely to tie together other packages -- Moose extensions and
other common modules.  Those other packages are largely by other people,
without whose work Reindeer would have a significantly smaller rack.

We also use documentation as written for the other packages pulled in here to
help present a cohesive whole.

=head1 SEE ALSO

L<Moose>, and all of the above-referenced packages.

=cut
