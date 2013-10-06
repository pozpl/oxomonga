package Markers::MarkersEditController;
use Moose;
use JSON;

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
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

1;