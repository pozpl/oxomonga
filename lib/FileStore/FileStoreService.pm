package FileStore::FileStoreService;

use Moose;
use File::DigestStore;

has 'root_path' => (
    'is' => 'ro',
    'isa' => 'Str',
    'required' => 1,
);

has 'url_base' => (
    'is' => 'ro',
    'isa' => 'Str',
    'required' => 1,
);

has 'store_provider' => (
    'is' => 'ro',
    'isa' => 'File::DigestStore',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return File::DigestStore->new(
            'root' => $self->root_path
        );
    },
);

sub store_file(){
    my($self, $path) = @_;

    my $id = $self->store_provider->store_path($path);
    return $id;
}

sub get_file_path(){
    my($self, $id) = @_;

    return $self->store_provider->fetch_file($id);
}

sub get_url_for_id(){
    my($self, $id) = @_;

    my $file_path = $self->store_provider->fetch_path($id);
    my $root_path = $self->root_path;
    my $url_base = $self->url_base;
    my $url = $file_path;
    if($url){
        $url =~ s/$root_path/$url_base/g;
    }
    return $url;
}


sub get_urls_for_ids(){
    my ($self, $ids_aref) = @_;

    my @ids_urls_array = ();
    foreach my $id (@{$ids_aref}){
        my $url_for_id = $self->get_url_for_id($id);
        if($url_for_id){
            push @ids_urls_array , {'id' => $id, 'url' => $url_for_id};
        }
    }

    return @ids_urls_array;
}

sub delete_file_by_id(){
    my ($self, $id) =@_;

    return $self->store_provider->delete($id);
}


1;