package Routes::RoutesRole;
use OX::Role;
use Plack::App::File;
use File::Basename;

#has 'current_working_directory' => (
#    'is' => 'ro',
#    'isa' => 'Str',
#);
my $current_working_directory  = dirname(__FILE__);

router as {
    route '/markers/near/radius'  => 'markers_rest_controller.find_near_markers';
    route '/markers/edit/show/form' => 'markers_edit_controller.show_form';

    mount '/static' => Plack::App::File->new(root => $current_working_directory . '/../../resources/static');
    #mount '/static' => "Plack::App::File", (
    #    root     => '../resources/static',
    #    encoding => literal('UTF-8'),
    #);
};

1;