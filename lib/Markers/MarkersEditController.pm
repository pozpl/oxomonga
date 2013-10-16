package Markers::MarkersEditController;
use Moose;


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

sub show_form(){
    my ($self, $request) = @_;

    return $self->template_view_handler->render_page('edit_marker_form');

}


1;