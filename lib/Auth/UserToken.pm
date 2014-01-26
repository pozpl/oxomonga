package Auth::UserToken;

use Moose;

has 'user_id' =>(
    is => 'ro',
    isa => 'Str',
    default => 0;
);

1;