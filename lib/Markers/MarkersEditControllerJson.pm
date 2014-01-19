package Markers::MarkersEditControllerJson;
use Moose;
use JSON;
use Markers::Marker;
use Data::Dump qw(dump);

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
    'required' => 1,
);

has 'file_store_service' => (
    'is'  => 'ro',
    'isa' => 'FileStore::FileStoreService',
    'required' => 1,
);

sub get_marker_by_id(){
    my ($self, $request, $marker_id) = @_;
    
    my $marker = $self->markers_repository->find_by_id($marker_id);
    return JSON->new->encode($self->_marker_to_hash($marker));
}

sub edit_marker(){
    my ($self, $request) = @_;
    my $marker_json_string =  $request->content;#param('marker');
    dump($marker_json_string);
    my $marker_json = JSON->new->decode($marker_json_string);
    my $marker_to_save = $self->_hash_to_marker($marker_json);

    my $saved_marker = $self->markers_repository->save_marker($marker_to_save);
    return JSON->new->encode($self->_marker_to_hash($saved_marker));
}



sub list_markers(){
    my ($self, $request) = @_;

}

sub delete_image_from_marker(){
    my ($self, $request) = @_;

    my $marker_json_string =  $request->content;
    my $request_json = JSON->new->decode($marker_json_string);

    my $marker_id = $request_json->{'marker_id'};
    my $image_id = $request_json->{'image_id'};
    my $delete_status = 0;
    if($marker_id && $image_id){
        $delete_status = $self->markers_repository->delete_image_from_marker($marker_id, $image_id);
    }

    return JSON->new->encode({
        'status' => $delete_status
    });

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
    my @marker_images_urls =  $self->file_store_service->get_urls_for_ids($marker->images);
    my $marker_hash = {
        'id' => $marker->id,
        'user' => $marker->user,
        'latitude' => $marker->latitude,
        'longitude' => $marker->longitude,
        'time_of_creation' => $marker->time_of_creation ? $marker->time_of_creation : time(),
        'description' => $marker->description,
        'images' => \@marker_images_urls,
    };
    print dump($marker_hash);
    return $marker_hash;
}

1;