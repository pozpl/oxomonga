package Markers::Marker;

use Moose;

has 'id' => ('is' => 'rw');

has 'user' => (
    'is' => 'ro',
);

has 'latitude' => (
    'is' => 'ro',
);

has 'longitude' => (
    'is' => 'ro',
);

has 'time_of_creation' => (
    'is' => 'ro',
);

has 'description' => (
    'is' => 'ro',
);

has 'images' => ('is' => 'ro');

1;