use WhereAreKittens;
use Config::ConfigProvider;
use File::Basename;

my $current_working_directory  = dirname(__FILE__);
my $config = Config::ConfigProvider->new(
                        'mode' => 'prod',
                        'config_dir' => $current_working_directory . '/../config/'
                    );
my $app = WhereAreKittens->new(  %{ $config->as_hash }, )->to_app;

$app;