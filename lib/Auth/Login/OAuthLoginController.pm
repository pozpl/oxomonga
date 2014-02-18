package Auth::Login::OAuthLoginController;

use Auth::UsersRepository;
use Auth::User;
use JSON;
use OAuth::Simple;

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

      if($provider_credentials){
        my $oauth = OAuth::Simple->new(
                      app_id     => $provider_credentials->{'app_id'},
                      secret     => $provider_credentials->{'app_secret'},
                      postback   => $request->uri_for(
                                            'name' => 'oauth_login',
                                            'provider' => $provider
                                            ),
                  );
        my $access = $oauth->request_access_token( {url => $provider_credentials->{'access_token_url'}, code => $args->{code}, raw => 1} );
        my $profile_data = $oauth->request_data( {url => $provider_credentials->{'profile_data_url'}, access_token => $access} );
    }
  return JSON->new->encode($authentication_status);
}

sub check_credentials_oauth(){
    my($self, $request, $provider) = @_;

    my $provider_credentials = $self->oauth_conf->{$provider};

    my $return = 0;

    if($provider_credentials){
         my $oauth = OAuth::Simple->new(
              app_id     => $provider_credentials->{'app_id'},
              secret     => $provider_credentials->{'app_secret'},
              postback   => $request->uri_for(
                                    'name' => 'oauth_login',
                                    'provider' => $provider
                                    ),
          );
         my $url = $oauth->authorize( {url => $provider_credentials->{'oauth_dialog'}, scope => 'email', response_type => 'code'} );
         # Your web app redirect method.
         $return = $request->new_response->redirect($url);

    }else{
         $return = 'unknown provider'
    }

    return $return;

}



1;