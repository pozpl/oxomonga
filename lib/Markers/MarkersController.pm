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
    $longitude = $longitude || 0;
    $latitude = $latitude  || 0;
    $radius = $radius || 0;
    
    my @markers = $self->markers_repository->find_near_markers($longitude, $latitude, $radius);
    my @markers_hrefs = $self->_markers_to_struct(\@markers);
    return encode_json(\@markers_hrefs);
}

sub _markers_to_struct(){
    my ($self, $markers) = @_;

    my @markers_hrefs_array = ();
    foreach my $marker (@{$markers}){
        my $marker_hash = {
             'id' => $marker->id(),
             'user' => $marker->user(),
             'latitude' => $marker->latitude(),
             'longitude' => $marker->longitude(),
             'time_of_creation' => $marker->time_of_creation(),
             'description' => $marker->description(),
             'images' => $marker->images(),
        };
        push  @markers_hrefs_array,  $marker_hash;
    }

    return @markers_hrefs_array;
}

1;