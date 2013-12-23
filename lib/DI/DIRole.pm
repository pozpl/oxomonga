package DI::DIRole;
use OX::Role;
use Text::Xslate;

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
        my $collection =  $s->param('database')->get_collection('markers');
        $collection->ensure_index({'loc' => '2dsphere'});
        return $collection;
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
        'file_store' => 'file_store',
    },
);

has template_root => (
    is    => 'ro',
    isa   => 'Str',
    value => 'resources/views/',
);

has xslate =>  (
    is           => 'ro',
    isa          => 'Text::Xslate',
    block => sub {
        my $s = shift;
        my $router = $s->param('router');
        return Text::Xslate->new(
        path     => [ $s->param('template_root') ],
        html_builder_module => [ 'HTML::FillInForm::Lite' => [qw(fillinform)] ],
        function => {
            uri_for => sub {
                    my ($spec) = @_;
                    return '/' . $router->uri_for(%$spec);
                },
            },
        );
    },
    dependencies => {
        'template_root' => 'template_root',
        'router' => 'Router'
    },
);

has template_view_handler => (
    is           => 'ro',
    isa          => 'System::View::TemplateViewHandler',
    dependencies => {
        'xslate' => 'xslate',
        'default_bounds' => literal({
            'static_path' => '/js/app'
        }),
    },

);

has markers_edit_controller =>(
    'is' => 'ro',
    'isa' => 'Markers::MarkersEditController',
    dependencies => {
       'markers_repository' => 'markers_repository',
       'template_view_handler' => 'template_view_handler',
    },
);

has markers_edit_controller_json =>(
    'is' => 'ro',
    'isa' => 'Markers::MarkersEditControllerJson',
    dependencies => {
       'markers_repository' => 'markers_repository',
       'template_view_handler' => 'template_view_handler',
    },
);

has 'file_store' => (
    'is' => 'ro',
    'isa' => 'FileStore::FileStoreService',
    'dependencies' => {
        'root_path' => '/tmp',
        'url_base' =>'http://127.0.0.1/'
    }
);

has 'upload_service' => (
    'is' => 'ro',
    'isa' => 'Markers::ImageUpload::UploadService',
    'dependencies' => {
        'file_store' => 'file_store',
        'markers_repository' =>'markers_repository',
    }
);

has 'upload_controller' => (
    'is' => 'ro',
    'isa' => 'Markers::ImageUpload::UploadController',
    'dependencies' => {
        'upload_service' => 'upload_service',
    }
);

1;