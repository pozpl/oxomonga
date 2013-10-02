package DI::DIRole;
use OX::Role;

has mongo =>(
    is => 'ro',
    isa => 'MongoDB::MongoClient',
    lifecycle => 'Singleton',
);

has mongo_database_name => (
    is       => 'ro',
    isa      => 'Str',
    default => 'development',
    lifecycle => 'Singleton',
);

has mongo_database => (
    is => 'ro',
    #isa => 'Misc::MongoDatabase',
    block => sub{
    	my $s = shift;
    	my $mongo_client = $s->param('mongo');
    	return $mongo_client->get_database($s->param('database_name'));
    },
    dependencies => {
    	'mongo' => 'mongo',
    	'database_name' => 'mongo_database_name'
    },
    lifecycle => 'Singleton',
);

has 'markers_collection' => (
    'is' => 'ro',
    'block' => sub{
        my $s = shift;
        return $s->param('database')->get_collection('markers');
    },
    dependencies => {
    	'database' => 'mongo_database',
    },
    lifecycle => 'Singleton',
);

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
    dependencies => {
    	'markers_collection' => 'markers_collection',
    },
);

has 'markers_rest_controller' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkersController',
    dependencies => {
        'markers_repository' => 'markers_repository',
    },
);

1;