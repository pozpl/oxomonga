package System::View::TemplateViewHandler;

use Moose;
use Text::Xslate;

has template_root => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has static_path => (
    'is' => 'ro',
    'isa' => 'Str',
    required => 1,
    default => '/static'
);

has xslate => (
    is      => 'ro',
    isa     => 'Text::Xslate',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return Text::Xslate->new(
            path     => [ $self->template_root ],
            function => {
                uri_for => sub {
                    my ($r, $spec) = @_;
                    return $r->uri_for($spec);
                },
            },
        );
    },
);

sub render_page {
    my $self = shift;
    my ($r, $page) = @_;
    return $self->xslate->render("$page.tx",
        {
            'r' => $r,
            'static_path' => $self->static_path
        });
}

1;