use WhereAreKittens;
use Config::ConfigProvider;

#use Plack::Middleware::Profiler::NYTProf;
#use  Plack::Middleware::InteractiveDebugger;
my $config = Config::ConfigProvider->new(
                        'mode' => 'dev',
                    );
my $app = WhereAreKittens->new(
                         %{ $config->as_hash },
                    )->to_app;
#$app = Plack::Middleware::Profiler::NYTProf->wrap($app);


#$app =  Plack::Middleware::InteractiveDebugger->wrap($app);

$app;