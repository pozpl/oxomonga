package Markers::Marker;

use Moose;

has 'id' => ('is' => 'rw');

has 'user' => (
    'is' => 'ro',
);

has 'latitude' => (
    'is' => 'ro',
    'isa' => 'Num'
);

has 'longitude' => (
    'is' => 'ro',
    'isa' => 'Num'
);

has 'time_of_creation' => (
    'is' => 'ro',
);

has 'description' => (
    'is' => 'ro',
);

has 'images' => ('is' => 'ro');

1;