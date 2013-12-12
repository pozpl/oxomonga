package FileStore::FileStoreService;

use Moose;
use File::DigestStore;

has 'root_path' => {
    'is' => 'ro',
    'isa' => 'Str',
}

has 'url_base' => {
    'is' => 'ro',
    'isa' => 'Str',
};

has 'store_provider' => {
    'is' => 'ro',
    'isa' => 'File::DigestStore'
}

sub store_file(){
    my($self, $path) = @_;

    my $id = $self->store_provider->store_path($path);

}


1;