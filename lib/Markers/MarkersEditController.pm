package Markers::MarkersEditController;
use Moose;
use Markers::Marker;

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
    my $marker;
    if($request->param('id') ){
         $marker = $self->markers_repository->find_by_id($request->param('id'));
         if($marker){

            $marker->user => $request->param('user'),
            $marker->latitude => $request->param('latitude'),
            $marker->longitude => $request->param('longitude'),
            $marker->description => $request->param('description'),
         }
    }else{
         $marker = Markers::Marker->new(
                                   'id' => $request->param('id'),
                                   'user' => $request->param('user'),
                                   'latitude' => $request->param('latitude'),
                                   'longitude' => $request->param('longitude'),
                                   'description' => $request->param('description'));
    }

    if($marker){#is valid condition
        $marker = $self->markers_repository->save_marker($marker);
    }

#    my $form_variables = {
#        'id' => $request->param('id'),
#        'user' => $request->param('user'),
#        'latitude' => $request->param('latitude'),
#        'longitude' => $request->param('longitude'),
#        'description' => $request->param('description'),
#    };

    return $self->template_view_handler->render_page('edit_marker_form',
                        {
                            'form' => $marker
                        });

}




1;