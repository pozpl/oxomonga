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
    route '/markers/near/radius/:longitude/:latitude/:radius'  => 'markers_rest_controller.find_near_markers';
    route '/markers/rectangle/:bl_lat/:bl_lon/:ur_lat/:ur_lon'  => 'markers_rest_controller.find_markers_in_rectangle';

    route '/markers/edit/show/form/?:id' => 'markers_edit_controller.show_form', (
            'name' => 'show_edit_form_id'
        );

    route '/markers/edit/delete/:id' => 'markers_edit_controller.delete_marker', (
        'name' => 'delete_marker_by_id'
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