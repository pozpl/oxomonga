package Auth::User;

use Moose;


has 'id' => (
    'is' => 'rw',
    'isa' => 'Str',
);


has 'login' => (
    'is' => 'rw',
    'isa' => 'Str',
);

has 'email' => (
    'is' => 'rw',
    'isa' => 'Str',
);

has 'friendly_name' => (
    'is' => 'rw',
    'isa' => 'Str',
);

has 'provider' => (
    'is' => 'rw',
    'isa' => 'Str'
);

has 'avatar' => (
    'is' => 'rw',
    'isa' => 'Str'
);

has 'password' => (
    'is' => 'rw',
    'isa' => 'Str',
);


1;