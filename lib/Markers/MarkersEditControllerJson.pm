package Markers::MarkersEditControllerJson;
use Moose;
use JSON;
use Markers::Marker;

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
    my $marker_json = JSON->new->decode($marker_json_string);
    my $marker_to_save = $self->_hash_to_marker($marker_json);

    my $user = $request->session->{Auth::Middleware::Token->user_session_key};
    if($marker_to_save->id){#only user can edit marker
        unless( $user && $user->id eq $marker_to_save->user){
            return $request->new_response(status => 401)->finalize;
        }
    }

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
        'status' => $delete_status ? 1 : 0
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
    return $marker_hash;
}

1;