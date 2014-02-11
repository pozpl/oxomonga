package Auth::Middleware::Token;

use Moose;
use MooseX::NonMoose;
extends 'Plack::Middleware';

use HTTP::Throwable::Factory 'http_exception';
use OX::Request;

has 'user_repository' => (
    'is'  => 'ro',
    'isa' => 'Auth::UsersRepository',
    'required' => 1,
);

sub call {
  my( $self , $env ) = @_;

  my $req = OX::Request->new(env => $env);

  # load the user data if there's a user_id set in the session
  if ( my $id = $req->session->{'user_id'} ) {
    my $user = $self->user_repository->find_by_id($id);
    if($user){
        $req->session->{'user'} = $user;
    }
  }

  return $self->app->($env);

}

__PACKAGE__->meta->make_immutable;
1;