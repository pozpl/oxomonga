package Markers::MarkersEditControllerJson;
use Moose;
use JSON;
use Markers::Marker;

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
    'required' => 1,
);

sub get_marker_by_id(){
    my ($self, $request, $marker_id) = @_;
    
    my $marker = $self->markers_repository->find_by_id($marker_id);
    return JSON->new->encode($self->_marker_to_hash($marker));
}

sub edit_marker(){
    my ($self, $request) = @_;
    my $marker_json_string = $request->param('marker');

    my $marker_json = JSON->new->decode($marker_json_string);
    my $marker_to_save = $self->_hash_to_marker($marker_json);

    my $saved_marker = $self->markers_repository->save_marker($marker_to_save);
    return $self->_marker_to_hash($saved_marker);
}



sub list_markers(){
    my ($self, $request) = @_;

}

sub _hash_to_marker(){
    my($self, $marker_json) = @_;

    return Markers::Marker->new(
             'id' => $marker_json->{'id'},
             'user' => $marker_json->{'user'},
             'latitude' => $marker_json->{'latitude'},
             'longitude' => $marker_json->{'longitude'},
             'description' => $marker_json->{'description'},
             'time_of_creation' => $marker_json->{'time_of_creation'},
             'images' => $marker_json->{'images'}
         );
}

sub _marker_to_hash(){
    my ($self, $marker) = @_;
    my $marker_hash = {
        'id' => $marker->id,
        'user' => $marker->user,
        'latitude' => $marker->latitude,
        'longitude' => $marker->longitude,
        'time_of_creation' => $marker->time_of_creation,
        'description' => $marker->description,
        'images' => $marker->images,
    };

    return $marker_hash;
}

1;