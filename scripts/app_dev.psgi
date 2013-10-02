use WhereAreKittens;
#use Plack::Middleware::Profiler::NYTProf;
my $app = WhereAreKittens->new()->to_app;
#$app = Plack::Middleware::Profiler::NYTProf->wrap($app);

$app;