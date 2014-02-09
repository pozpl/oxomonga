package Auth::User;

use Moose;
use MooseX::ClassAttribute;

class_has 'internal_provider' => ( is => 'ro', init_arg => undef, default => 'internal' );


has 'id' => (
    'is' => 'rw',
#    'isa' => 'Str',
);


has 'login' => (
    'is' => 'rw',
#    'isa' => 'Str',
);

has 'email' => (
    'is' => 'rw',
#    'isa' => 'Str',
);

has 'friendly_name' => (
    'is' => 'rw',
#    'isa' => 'Str',
);

has 'provider' => (
    'is' => 'rw',
#    'isa' => 'Str'
);

has 'avatar' => (
    'is' => 'rw',
#    'isa' => 'Str'
);

has 'password' => (
    'is' => 'rw',
#    'isa' => 'Str',
);


__PACKAGE__->meta()->make_immutable();

1;