package System::View::TemplateViewHandler;

use Moose;
use TExt::Xslate;

has template_root => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
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

1;