package WhereAreKittens;

use OX;
with('DI::DIRole');
with('Routes::RoutesRole');

router as {
     wrap 'Plack::Middleware::Session' => ( store => literal( 'File' ));
     wrap 'Auth::Middleware::Token' => ( user_repository => 'users_repository' );
};

1;