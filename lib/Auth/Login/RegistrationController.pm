package Auth::Login::RegistrationController;

use Moose;
use JSON;

use Auth::UsersRepository;
use Auth::User;

has 'user_repository' => (
    'is'  => 'ro',
    'isa' => 'Auth::UsersRepository',
    'required' => 1,
);

has 'file_store_service' => (
    'is'  => 'ro',
    'isa' => 'FileStore::FileStoreService',
    'required' => 1,
);

sub register_user(){
    my ($self, $request) = @_;
    my $user_json_string =  $request->content;
    my $user_json = JSON->new->decode($user_json_string);
    my $user_to_save = $self->_hash_to_user($user_json);
    my $user_login = $request->param('login');
    my $is_user_exists = $self->user_repository
                            ->check_login_existence(
                                 $user_login,
                                 Auth::User->internal_provider
                             );

    unless($is_user_exists){
        my $saved_user = $self->user_repository->save_user($user_to_save);
        return JSON->new->encode($self->_user_to_hash($saved_user));
    }else{
        return JSON->new->encode({
            'status'=> 'error',
            'error_message' => 'user with such login exists',
        })
    }


}

sub get_user_info(){
    my ($self, $request, $id) = @_;
    my $user_id = $id;
    my $user = $self->user_repository->find_by_id($user_id);
    my $user_hash = $self->_user_to_hash($user);

    return JSON->new->encode($user_hash);
}

sub is_user_with_login_exists(){
    my ($self, $request) = @_;

    my $user_login = $request->param('login');
    my $is_user_exists = $self->user_repository
                        ->check_login_existence(
                            $user_login,
                            Auth::User->internal_provider
                        );
    return JSON->new->encode({'login_exists' => $is_user_exists});
}


sub _hash_to_user(){
    my ($self, $user_hash) = @_;
    my $user = Auth::User->new();
    if($user_hash->{'id'}){$user->id( $user_hash->{'id'} );}
    if($user_hash->{'login'}){$user->login( $user_hash->{'login'} );}
    if($user_hash->{'email'}){$user->email( $user_hash->{'email'} );}
    if($user_hash->{'friendly_name'}){$user->friendly_name( $user_hash->{'friendly_name'} );}
    if($user_hash->{'password'}){$user->password( $user_hash->{'password'} );}

    $user->provider(Auth::User->internal_provider);
    return $user;
}

sub _user_to_hash(){
    my ($self, $user) = @_;

    my $user_hash = {
        'id'    => $user->id,
        'login' => $user->login,
        'email' => $user->email,
        'friendly_name' => $user->friendly_name,
        'provider' => $user->provider,
        'avatar' => $self->file_store_service->get_url_for_id($user->avatar),
    };


    return $user_hash;
}



1;