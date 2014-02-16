use WhereAreKittens;
use Config::ConfigProvider;
use File::Basename;

#use Plack::Middleware::Profiler::NYTProf;
#use  Plack::Middleware::InteractiveDebugger;

my $current_working_directory  = dirname(__FILE__);
my $config = Config::ConfigProvider->new(
                        'mode' => 'dev',
                        'config_dir' => $current_working_directory . '/../config/'
                    );

my $app = WhereAreKittens->new(
                         %{ $config->as_hash },
                    )->to_app;
#$app = Plack::Middleware::Profiler::NYTProf->wrap($app);


#$app =  Plack::Middleware::InteractiveDebugger->wrap($app);

$app;