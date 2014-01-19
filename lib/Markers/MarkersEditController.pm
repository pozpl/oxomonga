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
         if($marker){

            $marker = Markers::Marker->new(
                              'id' => $id,
                              'user' => $request->param('user') ? $request->param('user'): $marker->user(),
                              'latitude' => $request->param('latitude') ? $request->param('latitude') : $marker->latitude(),
                              'longitude' => $request->param('longitude') ? $request->param('longitude') : $marker->longitude(),
                              'description' => $request->param('description') ? $request->param('description') : $marker->description(),
                              'time_of_creation' => $marker->time_of_creation(),
                          );
         }
    }else{
         $marker = Markers::Marker->new(
                                   'user' => $request->param('user'),
                                   'latitude' => $request->param('latitude') ? $request->param('latitude') : 0,
                                   'longitude' => $request->param('longitude') ? $request->param('longitude') : 0,
                                   'description' => $request->param('description'),
                                   'time_of_creation' => time(),
                              );
    }
#    dump($marker);
    if($marker && $marker->user()){#is valid condition
        $marker = $self->markers_repository->save_marker($marker);
    }

    if($marker){
        return $self->template_view_handler->render_page('edit_marker_form',
                        {
                            'form' => $marker
                        });
    }else{
        return $request->new_response->redirect($request->uri_for({'name' => 'show_edit_list'}));
    }

}


sub list_markers(){
    my ($self, $request) = @_;

    my $page = $request->param('page') ? $request->param('page') : 1;
    my $offset = ($page -1) * $self->per_page;
    my ($markers_aref, $total_count) = $self->markers_repository->list_markers($offset, $self->per_page);

    my $addition_page = $total_count % $self->per_page > 0 ? 1 : 0;
    my $total_pages = int($total_count/$self->per_page) + $addition_page;
    my @pages_list = (1..$total_pages);
    return $self->template_view_handler->render_page('list_markers',
                                   {
                                       'markers' => $markers_aref,
                                       'total_count' => $total_count,
                                       'per_page' => $self->per_page,
                                       'page' => $page,
                                       'pages_list' => \@pages_list,
                                   });
}

sub delete_marker(){
    my ($self, $request) = @_;
    my $marker_id = $request->param('marker_id')| 0;
    my $image_id = $request->param('image_id') | 0;
    if($id){
        $self->markers_repository->delete_by_id($id);
        return 'OK';
    }else{
        return 'NOT OK';
    }

}

1;