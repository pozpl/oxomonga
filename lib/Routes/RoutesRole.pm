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
    route '/markers/edit/show/form' => 'markers_edit_controller.show_form', (
        'name' => 'show_edit_form'
    );

    route '/markers/edit/show/list' => 'markers_edit_controller.list_markers', (
        'name' => 'show_edit_list'
    );
    route '/markers/edit/get/marker/json/:id' => 'markers_edit_controller.get_marker_by_id',(
        'name' => 'marker_by_id_json',
    );

    mount '/static' => Plack::App::File->new(root => $current_working_directory . '/../../resources/static');
    #mount '/static' => "Plack::App::File", (
    #    root     => '../resources/static',
    #    encoding => literal('UTF-8'),
    #);
};

1;