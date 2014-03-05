package Auth::Middleware::Token;

use Moose;
use MooseX::NonMoose;
use MooseX::ClassAttribute;
extends 'Plack::Middleware';

use OX::Request;

class_has 'user_session_key' => ( is => 'ro', init_arg => undef, default => 'user' );
class_has 'user_id_session_key' => ( is => 'ro', init_arg => undef, default => 'user_id' );

has 'user_repository' => (
    'is'  => 'ro',
    'isa' => 'Auth::UsersRepository',
    'required' => 1,
);

sub call {
  my( $self , $env ) = @_;

  my $req = OX::Request->new(env => $env);

  my $router  = $env->{'ox.router'};
  my $route_match = $router->match($env->{'REQUEST_URI'});
  if($route_match){
      my $route_mapping = $route_match->mapping();
      if($route_mapping->{'auth'}){
          # load the user data if there's a user_id set in the session
          if ( my $id = $req->session->{Auth::Middleware::Token->user_id_session_key} ) {
            my $user = $self->user_repository->find_by_id($id);
            if($user){
                $req->session->{Auth::Middleware::Token->user_session_key} = $user;
            }
          }else{
             return $req->new_response(status => 401)->finalize;
          }
      }
  }

  return $self->app->($env);

}

__PACKAGE__->meta->make_immutable;
1;