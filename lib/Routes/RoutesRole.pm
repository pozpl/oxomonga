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
    route '/markers/rectangle/:bl_lon/:bl_lat/:ur_lon/:ur_lat'  => 'markers_rest_controller.find_markers_in_rectangle';

    route '/markers/edit/show/form/?:id' => 'markers_edit_controller.show_form', (
            'name' => 'show_edit_form_id'
        );

    route '/markers/edit/delete/:id' => 'markers_edit_controller.delete_marker', (
        'name' => 'delete_marker_by_id'
    );

    route '/markers/edit/show/list' => 'markers_edit_controller.list_markers', (
        'name' => 'show_edit_list'
    );
    route '/markers/get/marker/json/:marker_id' => 'markers_edit_controller_json.get_marker_by_id',(
        'name' => 'marker_by_id_json',
    );

    route '/markers/edit/json' => 'markers_edit_controller_json.edit_marker',(
        'name' => 'edit_marker_json',
    );

    route '/marker/upload/images' => 'upload_controller.process_upload',(
        'name' => 'upload_images',
    );

    route '/delete/marker/image' => 'markers_edit_controller_json.delete_image_from_marker',(
        'name' => 'delete_image_from_marker',
    );



    mount '/static' => Plack::App::File->new(root => $current_working_directory . '/../../resources/static');
    mount '/js/app' => Plack::App::File->new(root => $current_working_directory . '/../../resources/static/js/app');

    #image_store root url
    mount '/user/images' => Plack::App::File->new(root => $current_working_directory . '/../../../../tmp/image_store');

    #mount '/static' => "Plack::App::File", (
    #    root     => '../resources/static',
    #    encoding => literal('UTF-8'),
    #);
};

1;