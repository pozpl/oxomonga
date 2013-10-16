package Markers::MarkersEditControllerJson;
use Moose;
use JSON;

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
    'required' => 1,
);

has 'template_view_handler' => (
    'is' => 'ro',
    'isa' => 'System::View::TemplateViewHandler',
    'required' => 1,
);

sub get_marker_by_id(){
    my ($self, $marker_id) = @_;
    
    my $marker = $self->markers_repository->find_by_id($marker_id);
    return encode_json({
         'id' => $marker->id,
         'user' => $marker->user,
         'latitude' => $marker->latitude,
         'longitude' => $marker->longitude,
         'time_of_creation' => $marker->time_of_creation,
         'description' => $marker->description,
         'images' => $marker->images,
    });
}

sub edit_marker(){
    my ($self, $request) = @_;
    my $form_json = $request->param('form');
    
    $self->markers_repository->save_marker();
    return 1;
}

sub show_form(){
    my ($self, $request) = @_;

    return $self->template_view_handler->render_page('edit_marker');

}

sub list_markers(){
    my ($self, $request) = @_;

}

sub _marker_to_hash(){
    my ($self, $marker) = @_;
    my $marker_hash = {
        'id' => $marker->id,
        'user' => $marker->user,
        'latitude' => $marker->latitude,
        'longitude' => $marker->longitude,
        'time_of_creation' => $marker->time_of_creation,
        'description' => $marker->description,
        'images' => $marker->images,
    };
}

1;