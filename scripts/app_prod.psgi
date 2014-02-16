use WhereAreKittens;
use Config::ConfigProvider;

my $config = Config::ConfigProvider->new(
                        'mode' => 'prod',
                    );
my $app = WhereAreKittens->new(
                         %{ $config->as_hash },
                    )->to_app;

$app;