use WhereAreKittens;
#use Plack::Middleware::Profiler::NYTProf;
#use  Plack::Middleware::InteractiveDebugger;

my $app = WhereAreKittens->new()->to_app;
#$app = Plack::Middleware::Profiler::NYTProf->wrap($app);


#$app =  Plack::Middleware::InteractiveDebugger->wrap($app);

$app;