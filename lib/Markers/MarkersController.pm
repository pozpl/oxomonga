package Markers::MarkersController;

use Moose;
use JSON;

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
    'required' => 1,
);

sub find_near_markers(){
    my ($self, $request, $longitude, $latitude, $radius) = @_;
    my $longitude = $longitude || 0;
    my $latitude = $latitude  || 0;
    my $radius = $radius || 0;
    
    my @markers = $self->markers_repository->find_near_markers($longitude, $latitude, $radius);
    return encode_json(\@markers);
}

1;