package Auth::User;

use Moose;


has 'id' => (
    'is' => 'ro',
    'isa' => 'Int',
);


has 'login' => (
    'is' => 'ro',
    'isa' => 'Str',
);

has 'friendly_name' => (
    'is' => 'ro',
    'isa' => 'Str',
);

has 'provider' => (
    'is' => 'ro',
    'isa' => 'Str'
);

has 'avatar' => (
    'is' => 'ro',
    'isa' => 'Str'
);
1;