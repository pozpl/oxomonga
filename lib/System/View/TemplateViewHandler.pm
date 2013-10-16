package System::View::TemplateViewHandler;

use Moose;
use Text::Xslate;
use Data::Dump qw(dump);

has default_bounds => (
    'is' => 'ro',
    'isa' => 'HashRef',
);

#has template_root => (
#    is       => 'ro',
#    isa      => 'Str',
#    required => 1,
#);

#has static_path => (
#    'is' => 'ro',
#    'isa' => 'Str',
#    required => 1,
#    default => '/static'
#);

has xslate => (
    is      => 'ro',
    isa     => 'Text::Xslate',
#    lazy    => 1,
#    default => sub {
#        my $self = shift;
#        return Text::Xslate->new(
#            path     => [ $self->template_root ],
#            function => {
#                uri_for => sub {
#                    my ($r, $spec) = @_;
#                    return $r->uri_for($spec);
#                },
#            },
#        );
#    },
);

sub render_page {
    my $self = shift;
    my ($page, $bounds) = @_;
    my %result_bounds = %{$self->default_bounds};
    if($bounds){
        my %bounds_hash = %{$bounds};
        @result_bounds{keys %bounds_hash} = values %bounds_hash;
    }
    return $self->xslate->render("$page.tx", \%result_bounds);
}

1;