package DI::DIRole;
use Moose::Role;

has mongo =>(
    is => 'ro',
    isa => 'MongoDB::MongoClient',
    lifecycle => 'Singleton',
);

has mongo_database_name => (
    is       => 'ro',
    isa      => 'Str',
    default => 'markers',
    lifecycle => 'Singleton',
);

has test_database => (
    is => 'ro',
    #isa => 'Misc::MongoDatabase',
    block => sub{
    	my $s = shift;
    	Misc::MongoDatabase->get_database(
    	   $s->param('mongo'), 
    	   $s->param('database_name')
    	);
    },
    dependencies => {
    	'mongo' => 'mongo',
    	'database_name' => 'mongo_database_name'
    },
    lifecycle => 'Singleton',
    
);
1;