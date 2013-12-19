package Markers::ImageUpload::UploadService;
use Moose;

has 'file_store' => (
    'is' => 'ro',
    'isa' => 'FileStore::FileStoreService',
);

#########################################################################
# Usage      : @files_ids = save_uploads($uploads_aref);
# Purpose    : save uplads to filestorage and get ids of files
# Returns    : array of file ids
# Parameters : $uplads_aref array reference for Wev::Request::Upload
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub save_upload(){
    my ($self, $uploads_aref) = @_;

    my @uploaded_files_ids = ();
    foreach my $tmp_file (@{$uploads_aref}){
        my $tmp_file_name = $tmp_file->tempname;
        if(-e $tmp_file_name){ #here will be proper validation
            my $file_id = $self->file_store->store_file($tmp_file_name);
            push @uploaded_files_ids, $file_id;
        }
    }

    return @uploaded_files_ids;
}

1;