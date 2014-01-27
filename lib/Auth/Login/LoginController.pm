package Auth::Login::LoginController;

use Moose;
use Auth::UserRepository;
use Auth::User;

sub login {
  my( $self , $req ) = @_;

  my $login_error;

  my $username = $req->param( 'username' ) // '';

  if ( $req->method eq 'POST' ) {
    my $user = $self->model->resultset('Users')->find({ username => $username });
    if ( $user and $user->check_passphrase( $req->param( 'password' ))) {
      $req->session->{user_id} = $username;

      my $redir = delete $req->session->{redir_to};
      $redir //= '/';

      http_throw( Found => { location => $redir });
    }
    else { $login_error = 'Wrong user or password' }
  }

  return $self->render(
    'login.tx' , {
      error => $login_error ,
      title => 'Login' ,
      username => $username
    });
}

1;