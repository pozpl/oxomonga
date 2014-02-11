package Auth::Login::LoginController;

use Moose;
use Auth::UsersRepository;
use Auth::User;
use JSON;
has 'user_repository' => (
    'is'  => 'ro',
    'isa' => 'Auth::UsersRepository',
    'required' => 1,
);

sub login {
  my( $self , $req ) = @_;

  my $login_error;

  my $user_credentials_json_string = $req->content;
  my $user_credentials = JSON->new->decode($user_credentials_json_string);
  my $username = $user_credentials->{'login'} // '';
  my $password = $user_credentials->{'password'} // '';

  my $authentication_status = {'status' => 'login error'};

  if ( $req->method eq 'POST' ) {
    if ( $self->user_repository->check_login_password($username, $password, Auth::User->internal_provider)) {
      my $user = $self->user_repository->find_by_login_provider($username, Auth::User->internal_provider);

      $req->session->{'user_id'} = $user->id();

      $authentication_status = {
            'status' => 'ok',
            'user_id' => $user->id(),
      };
    }
  }

  return JSON->new->encode($authentication_status);
}

sub logout(){
    my ($self, $req) = @_;
    delete($req->session->{'user_id'});

    return JSON->new->encode({'status' => 'ok'});
}

1;