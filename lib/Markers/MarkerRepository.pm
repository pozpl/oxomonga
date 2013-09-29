package Markers::MarkerRepository;

use Moose;
use MongoDB::OID;
use Markers::Marker;

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
    
    my @markers = $self->markers_collection->find(
        {
            loc => {
                ' $near' => {
                    '$geometry' => {
                    type => "Point" ,
                    coordinates => [ $longitude , $latitude ]
                    }
                },
                '$maxDistance' => $max_distance,
            }
        })->all();
    return @markers;
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
        $hash_to_save->{loc} = {
            'type' => 'Point',
            'coordinates' => [$marker->longitude() , $marker->latitude()]
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