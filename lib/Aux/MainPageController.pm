package Aux::MainPageController;

use Moose;

has 'template_view_handler' => (
    'is' => 'ro',
    'isa' => 'System::View::TemplateViewHandler',
    'required' => 1,
);



sub show{
    my ($self, $request) = @_;
    return $self->template_view_handler->render_page('index',
                        {
#                            'form' => $marker
                        });
}



1;