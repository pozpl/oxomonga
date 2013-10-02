package Markers::MarkersController;

use Moose;
use JSON;

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkersRepository',
    'required' => 1,
);

sub find_near_markers(){
    my ($self, $request) = @_;
    my $longitude = $request->param('lon') || 0;
    my $latitude = $request->param('lat')  || 0;
    my $radius = $request->param('radius') || 0;
    
    my @markers = $self->markers_repository->find_near_markers($longitude, $latitude, $radius);
    return encode_json(\@markers);
}

1;