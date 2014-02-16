package Config::ConfigProvider;

use 5.16.0;
use Moose;
use Config::JFDI;

has mode => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has filename => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $mode = $self->mode;
        "config.$mode.yml"
    },
);

has config => (
    is => 'ro',
    isa => 'Config::JFDI',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return Config::JFDI->new(
            name => $self->filename,
            path => 'config/',
        );
    },
);

sub get {
    my ($self, $key) = @_;
    return $self->config->config->{$key};
}

sub as_hash {
    my ($self) = @_;
    return $self->config->config;
}

1;