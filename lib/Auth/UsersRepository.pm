package Auth::UserRepository;

use MongoDB::OID;
use Auth::User;
use Tie::IxHash;

has 'users_collection' => (
    'is'=> 'ro',
    'isa' => 'MongoDB::Collection',
);

has 'password_crypt' => (
    'is' => 'ro',
    'isa' => 'Crypt::PBKDF2',
);

sub save_user(){
    my ($self, $user) = @_;
    
    my $saved_user;
    if ($user->id()) {
        $saved_user = $self->_update_user($user);
    }else{
        $saved_user = $self->_insert_user($user);
    }
    
    return $saved_user;    
}

sub find_by_id(){
    my ($self, $id) = @_;
    
    my $users_hash = $self->users_collection->find_one({'_id' => MongoDB::OID->new('value' => $id)});
    my $user = undef;
    if ($users_hash) {
        $user = $self->_hash_to_user($users_hash);
    }
    
    return $user;
}


sub list_users(){
    my ($self, $offset, $limit) = @_;

    my $raw_users_cursor = $self->users_collection->find()
                            ->skip($offset)
                            ->limit($limit);
    my $total_count = $raw_users_cursor->count();
    my @users = ();
    while( my $raw_user = $raw_users_cursor->next ){
       push @users, $self->_hash_to_user($raw_user);
    }
    return (\@users, $total_count);
}

sub delete_by_id(){
    my ($self, $id) = @_;
    
    my $is_delete_ok = $self->users_collection->remove({
                            '_id' => MongoDB::OID->new('value' => $id)
                            });
    return $is_delete_ok;
}

sub _insert_user(){
    my ($self, $user) = @_;
    
    my $hash_to_save = $self->_user_to_hash($user);
    my $oid = $self->users_collection
                ->insert($hash_to_save);
    $user->id($oid->to_string());
    return $user;
}

sub _update_user(){
    my ($self, $user) = @_;
    
    my $hash_to_save = $self->_user_to_hash($user);
    $self->users_collection->update(
                    {_id => MongoDB::OID->new('value'=>$user->id())},
                    $hash_to_save);
    
    return $user;
}

sub _user_to_hash(){
    my ($self, $user) = @_;
    
    my $hash_to_save = {};
    
    if ($user->user()) {
        $hash_to_save->{'user'} = $user->user();
    }
    
    if ($user->longitude() && $user->latitude()) {
        $hash_to_save->{'loc'} = {
            'type' => 'Point',
            'coordinates' => [$user->longitude() + 0 , $user->latitude() + 0]
        };
    }
    
    if ($user->time_of_creation()) {
        $hash_to_save->{'time_of_creation'} = $user->time_of_creation();
    }
    
    if ($user->description()) {
        $hash_to_save->{'description'} = $user->description();
    }
    
    if ($user->images()) {
        $hash_to_save->{'images'} = $user->images();
    }
    
    return $hash_to_save;
}

sub _hash_to_user(){
    my ($self, $user_doc_hash_ref) = @_;
    
    my $user = users::user->new({
        'id' => $user_doc_hash_ref->{'_id'}->to_string(),
        'user' => $user_doc_hash_ref->{'user'},
        'latitude' => $user_doc_hash_ref->{'loc'}->{'coordinates'}[1],
        'longitude' => $user_doc_hash_ref->{'loc'}->{'coordinates'}[0],
        'time_of_creation' => $user_doc_hash_ref->{'time_of_creation'},
        'description' => $user_doc_hash_ref->{'description'},
        'images' => $user_doc_hash_ref->{'images'},
    });
                                   
    return $user;
}

1;