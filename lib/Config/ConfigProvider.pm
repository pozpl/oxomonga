package Config::ConfigProvider;

use 5.16.0;
use Moose;
use Config::JFDI;

has filename => (
    is => 'ro',
    isa => 'Str',
    default => sub { "myapp.$ENV{MYAPP_CONFIG_SUFFIX}" },
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