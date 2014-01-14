package Markers::MarkerRepository;

use Moose;
use MongoDB::OID;
use Markers::Marker;
use Tie::IxHash;

has 'markers_collection' => (
    'is'=> 'ro',
    'isa' => 'MongoDB::Collection',
);

sub save_marker(){
    my ($self, $marker) = @_;
    
    my $saved_marker;
    if ($marker->id()) {
        $saved_marker = $self->_update_marker($marker);
    }else{
        $saved_marker = $self->_insert_marker($marker);
    }
    
    return $saved_marker;    
}

sub find_by_id(){
    my ($self, $id) = @_;
    
    my $markers_hash = $self->markers_collection->find_one({'_id' => MongoDB::OID->new('value' => $id)});
    my $marker = undef;
    if ($markers_hash) {
        $marker = $self->_hash_to_marker($markers_hash);
    }
    
    return $marker;
}

sub find_near_markers(){
    my ($self, $longitude, $latitude, $max_distance) = @_;
    
    
    my $query = Tie::IxHash->new('loc' => Tie::IxHash->new(
        '$near' => 
        {
            '$geometry' => {
                'coordinates' => [ $longitude + 0 , $latitude + 0],
                'type' => 'Point',
            }
        },
        '$maxDistance' => $max_distance + 0
    ));

    my @raw_markers = $self->markers_collection->find($query)->all();
    my @markers = ();
    foreach my $raw_marker (@raw_markers) {
        push @markers, $self->_hash_to_marker($raw_marker);
    }
    return @markers;
}

sub find_markers_in_rectangle(){
    my ($self, $bl_longitude, $bl_latitude, $ur_longitude, $ur_latitude) = @_;

    my $query = Tie::IxHash->new('loc' => Tie::IxHash->new(
           '$geoWithin' => {
                '$box' => [
                    [$bl_longitude + 0 , $bl_latitude + 0],
                    [$ur_longitude + 0 , $ur_latitude + 0],
                ],
           }
        ));

    my @raw_markers = $self->markers_collection->find($query)->all();
    my @markers = ();
    foreach my $raw_marker (@raw_markers) {
        push @markers, $self->_hash_to_marker($raw_marker);
    }
    return @markers;
}

sub count_markers_in_rectangle(){
     my ($self, $bl_longitude, $bl_latitude, $ur_longitude, $ur_latitude) = @_;

        my $query = Tie::IxHash->new('loc' => Tie::IxHash->new(
               '$geoWithin' => {
                    '$box' => [
                        [$bl_longitude + 0 , $bl_latitude + 0],
                        [$ur_longitude + 0 , $ur_latitude + 0],
                    ],
               }
            ));

        my $markers_count = $self->markers_collection->find($query)->count();
        return $markers_count;
}

sub list_markers(){
    my ($self, $offset, $limit) = @_;

    my $raw_markers_cursor = $self->markers_collection->find()
                            ->skip($offset)
                            ->limit($limit);
    my $total_count = $raw_markers_cursor->count();
    my @markers = ();
    while( my $raw_marker = $raw_markers_cursor->next ){
       push @markers, $self->_hash_to_marker($raw_marker);
    }
    return (\@markers, $total_count);
}

sub add_image_to_marker(){
    my ($self, $marker_id, $image_id) = @_;

     my $find_query = {'_id' => MongoDB::OID->new('value' => $marker_id)};
     my $update_query = {
                            '$addToSet' => { 'images' => $image_id  }
                        };

     $self->markers_collection->update($find_query, $update_query);
}

sub add_images_to_marker(){
    my ($self, $marker_id, $images_aref) = @_;

     my $find_query = Tie::IxHash->new ('_id' => MongoDB::OID->new( $marker_id));
     my $update_query = {
                            '$addToSet' => { 'images' => {'$each' => $images_aref}  }
                        };

     my $update_status = $self->markers_collection->update($find_query, $update_query, {safe => 1});
     my @marker_with_images =  $self->markers_collection->find($find_query)->all();

     return $update_status;
}

sub delete_image_from_marker(){
    my ($self, $marker_id, $image_id) = @_;

    my $find_query = {'_id' => MongoDB::OID->new('value' => $marker_id)};
    my $delete_query = {'$pull' => {'images' => $image_id} };
    $self->markers_collection->update($find_query, $delete_query);
}

sub delete_by_id(){
    my ($self, $id) = @_;
    
    my $is_delete_ok = $self->markers_collection->remove({
                            '_id' => MongoDB::OID->new('value' => $id)
                            });
    return $is_delete_ok;
}

sub _insert_marker(){
    my ($self, $marker) = @_;
    
    my $hash_to_save = $self->_marker_to_hash($marker);
    my $oid = $self->markers_collection
                ->insert($hash_to_save);
    $marker->id($oid->to_string());
    return $marker;
}

sub _update_marker(){
    my ($self, $marker) = @_;
    
    my $hash_to_save = $self->_marker_to_hash($marker);
    $self->markers_collection->update(
                    {_id => MongoDB::OID->new('value'=>$marker->id())},
                    $hash_to_save);
    
    return $marker;
}

sub _marker_to_hash(){
    my ($self, $marker) = @_;
    
    my $hash_to_save = {};
    
    if ($marker->user()) {
        $hash_to_save->{'user'} = $marker->user();
    }
    
    if ($marker->longitude() && $marker->latitude()) {
        $hash_to_save->{'loc'} = {
            'type' => 'Point',
            'coordinates' => [$marker->longitude() + 0 , $marker->latitude() + 0]
        };
    }
    
    if ($marker->time_of_creation()) {
        $hash_to_save->{'time_of_creation'} = $marker->time_of_creation();
    }
    
    if ($marker->description()) {
        $hash_to_save->{'description'} = $marker->description();
    }
    
    if ($marker->images()) {
        $hash_to_save->{'images'} = $marker->images();
    }
    
    return $hash_to_save;
}

sub _hash_to_marker(){
    my ($self, $marker_doc_hash_ref) = @_;
    
    my $marker = Markers::Marker->new({
        'id' => $marker_doc_hash_ref->{'_id'}->to_string(),
        'user' => $marker_doc_hash_ref->{'user'},
        'latitude' => $marker_doc_hash_ref->{'loc'}->{'coordinates'}[1],
        'longitude' => $marker_doc_hash_ref->{'loc'}->{'coordinates'}[0],
        'time_of_creation' => $marker_doc_hash_ref->{'time_of_creation'},
        'description' => $marker_doc_hash_ref->{'description'},
        'images' => $marker_doc_hash_ref->{'images'},
    });
                                   
    return $marker;
}




1;