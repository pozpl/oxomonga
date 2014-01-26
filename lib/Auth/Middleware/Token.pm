package Auth::Middleware::Token;

use Moose;
use MooseX::NonMoose;
extends 'Plack::Middleware';

use HTTP::Throwable::Factory 'http_exception';
use OX::Request;
use Auth::UserToken;
#has model => (
#  is => 'ro',
#  isa => 'OXauth::Schema' ,
#  required => 1,
#  handles => [ qw/ load_user / ] ,
#);

sub call {
  my( $self , $env ) = @_;

  my $req = OX::Request->new(env => $env);

  #my $login_url = $req->uri_for('login');

  # load the user data if there's a user_id set in the session
  if ( my $id = $req->session->{'user_id'} ) {
    my $userToken = Auth::UserToken->new(
        'user_id' => $id;
    );
    $req->session->{'user_token'} = $user_token;
  }

  # if we have a user or if we're trying to login, carry on
#  if ( $req->session->{user} || $req->uri->path eq $login_url) {
#    return $self->app->($env);
#  }
#  # otherwise redirect to the login url
#  else {
#    return $req->new_response->redirect( $login_url );
#  }
}

__PACKAGE__->meta->make_immutable;
1;