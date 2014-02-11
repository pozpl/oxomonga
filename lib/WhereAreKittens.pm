package WhereAreKittens;

use OX;
with('DI::DIRole');
with('Routes::RoutesRole');

routes as {
     wrap 'Plack::Middleware::Session' => ( store => literal( 'File' ));
     wrap 'Auth::Middleware::Token' => ( user_repository => 'user_repository' );
}

1;