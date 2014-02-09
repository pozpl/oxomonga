package Auth::UsersRepository;

use Moose;
use MongoDB::OID;
use Auth::User;
use Tie::IxHash;
use Crypt::PBKDF2;

has 'users_collection' => (
    'is'=> 'ro',
    'isa' => 'MongoDB::Collection',
    'required' => 1,
);

has 'password_crypt' => (
    'is' => 'ro',
    'isa' => 'Crypt::PBKDF2',
    'default' => sub{
        return Crypt::PBKDF2->new(
        	hash_class => 'HMACSHA2',
        	hash_args => {
        		sha_size => 512,
        	},
            salt_len => 4,
        );
    },
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

sub check_login_existence(){
    my ($self, $user_login, $provider) = @_;
    my $user = $self->users_collection->find_one({'login' => $user_login, 'provider' => $provider});
    return $user ? 1 : 0;
}

sub check_user_password(){
    my ($self, $user_id, $user_password) = @_;

    my $user_hash = $self->users_collection->find_one({'_id' => MongoDB::OID->new('value' => $user_id)});
    my $password_hash = $user_hash->{'password'};
    my $check_status = $self->password_crypt->validate($password_hash, $user_password);
    return $check_status;
}

sub change_user_password(){
    my  ($self, $user_id,$old_password, $new_password) = @_;

    if($self->check_user_password($user_id, $old_password)){
        $self->users_collection->update(
            {'_id' => MongoDB::OID->new('value' => $user_id)},
            {'password' =>  $self->password_crypt->generate($user->password) }
        );
    }

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
    
    if ($user->login){$hash_to_save->{'login'} = $user->login;}
    if ($user->email){$hash_to_save->{'email'} = $user->email;}
    if ($user->friendly_name){$hash_to_save->{'friendly_name'} = $user->friendly_name;}
    if ($user->provider){$hash_to_save->{'provider'} = $user->provider;}
    if ($user->provider){$hash_to_save->{'avatar'} = $user->avatar;}
    if ($user->password){
        $hash_to_save->{'password'} = $self->password_crypt->generate($user->password);
    }

    return $hash_to_save;
}

sub _hash_to_user(){
    my ($self, $user_doc_hash_ref) = @_;
    
    my $user = Auth::User->new({
        'id' => $user_doc_hash_ref->{'_id'}->to_string(),
        'login' => $user_doc_hash_ref->{'login'},
        'email' => $user_doc_hash_ref->{'email'},
        'friendly_name' => $user_doc_hash_ref->{'friendly_name'},
        'provider' => $user_doc_hash_ref->{'provider'},
        'avatar' => $user_doc_hash_ref->{'avatar'},
    });
                                   
    return $user;
}

1;