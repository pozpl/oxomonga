package Markers::MarkersEditController;
use Moose;
use Markers::Marker;
use Data::Dump qw(dump);

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

has 'per_page' => (
    'is' => 'ro',
    'isa' => 'Int',
    'default' => 30,
    'required' => 1,
);

sub show_form(){
    my ($self, $request, $id) = @_;
    my $marker;
    if($id){
         $marker = $self->markers_repository->find_by_id($id);
         dump($marker);
         if($marker){

            $marker->user => $request->param('user'),
            $marker->latitude => $request->param('latitude'),
            $marker->longitude => $request->param('longitude'),
            $marker->description => $request->param('description'),
         }
    }else{
         $marker = Markers::Marker->new(
                                   'user' => $request->param('user'),
                                   'latitude' => $request->param('latitude'),
                                   'longitude' => $request->param('longitude'),
                                   'description' => $request->param('description'));
    }

    if($marker->user){#is valid condition
        $marker = $self->markers_repository->save_marker($marker);
    }

    return $self->template_view_handler->render_page('edit_marker_form',
                        {
                            'form' => $marker
                        });

}


sub list_markers(){
    my ($self, $request) = @_;

    my $page = $request->param('page') ? $request->param('page') : 1;
    my $offset = ($page -1) * $self->per_page;
    my ($markers_aref, $total_count) = $self->markers_repository->list_markers($offset, $self->per_page);


    return $self->template_view_handler->render_page('list_markers',
                                   {
                                       'markers' => $markers_aref,
                                       'total_count' => $total_count,
                                   });
}

sub delete_marker(){
    my ($self, $request, $id) = @_;

    if($id){
        $self->markers_repository->delete_by_id($id);
        return 'OK';
    }else{
        return 'NOT OK';
    }

}

1;