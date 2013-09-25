package Markers::MarkersController;

use Moose;
use JSON;

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkersRepository',
    'required' => 1,
);

sub find_near_markers(){
    my ($self, $longitude, $latitude, $radius) = @_;
    
    my @markers = $self->markers_repository->find_near_markers($longitude, $latitude, $radius);
    return encode_json(\@markers);
}

1;