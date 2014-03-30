package Auth::Login::LoginOAuthController;

use Moose;
use Net::OAuth2::Client;

sub client {
        Net::OAuth2::Client->new(
                config->{client_id},
                config->{client_secret},
                site => 'https://graph.facebook.com',
        )->web_server(
          redirect_uri => uri_for('/login/oauth-callback')
        );
}

  # Send user to authorize with service provider
sub login(){
        my ($self, $request) = @_;
        return $request->new_response->redirect(client->authorize_url);
};

  # User has returned with '?code=foo' appended to the URL.

#get '/auth/facebook/callback' => sub {
sub callback(){
    my ($self, $request) = @_;
    # Use the auth code to fetch the access token
    my $access_token =  client->get_access_token(params->{code});

    # Use the access token to fetch a protected resource
    my $response = $access_token->get('/me');

    # Do something with said resource...

    if ($response->is_success) {
        return "Yay, it worked: " . $response->decoded_content;
    }else {
        return "Error: " . $response->status_line;
    }
}



1;