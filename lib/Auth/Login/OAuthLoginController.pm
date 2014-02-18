package Auth::Login::OAuthLoginController;

use Auth::UsersRepository;
use Auth::User;
use JSON;
use LWP::Authen::OAuth2;
use Data::Dump qw(dump);

has 'user_repository' => (
    'is'  => 'ro',
    'isa' => 'Auth::UsersRepository',
    'required' => 1,
);

has 'oauth_conf' => (
    'is' => 'ro',
    'required' => 1,
);

sub login {
  my( $self , $req, $provider ) = @_;

   my $provider_credentials = $self->oauth_conf->{$provider};

   my $return = 0;
   $code = $req->param('code');

   if($provider_credentials && $code){
       my $oauth2 = LWP::Authen::OAuth2->new(
                             client_id => $provider_credentials->{'app_id'},
                             client_secret => $provider_credentials->{'app_secret'},
                             service_provider => $provider,
                             redirect_uri => $request->uri_for(
                                                'name' => 'oauth_login',
                                                'provider' => $provider
                                              ),

                             # Optional hook, but recommended.
                             #save_tokens => \&save_tokens,
                             # This is for when you have tokens from last time.
                             #token_string => $token_string.
                         );

        # URL for user to go to to start the process.
       $token_string  = $oauth2->request_tokens(code => $code);

  }
  return JSON->new->encode($authentication_status);
}

sub check_credentials_oauth(){
    my($self, $request, $provider) = @_;

    my $provider_credentials = $self->oauth_conf->{$provider};

    my $return = 0;

    if($provider_credentials){
         my $oauth2 = LWP::Authen::OAuth2->new(
                                      client_id => $provider_credentials->{'app_id'},
                                      client_secret => $provider_credentials->{'app_secret'},
                                      service_provider => $provider,
                                      redirect_uri => $request->uri_for(
                                                         'name' => 'oauth_login',
                                                         'provider' => $provider
                                                       ),

                                      # Optional hook, but recommended.
                                      #save_tokens => \&save_tokens,
                                      # This is for when you have tokens from last time.
                                      #token_string => $token_string.
                                  );

                     # URL for user to go to to start the process.
         my $url = $oauth2->authorization_url();

         $return = $request->new_response->redirect($url);

    }else{
         $return = 'unknown provider'
    }

    return $return;

}



1;