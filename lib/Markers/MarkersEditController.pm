package Markers::MarkersEditController;
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
    return encode_json($marker);
}

sub edit_marker(){
    my ($self, $request) = @_;
    my $form_json = $request->param('form');
    
    $self->markers_repository->save_marker();
    return 1;
}

sub show_form(){
    my ($self, $request) = @_;

    return $self->template_view_handler->render_page($request, 'layout');

}

1;