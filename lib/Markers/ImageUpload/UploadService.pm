package Markers::ImageUpload::UploadService;
use Moose;

has 'file_store' => (
    'is' => 'ro',
    'isa' => 'FileStore::FileStoreService',
);

has 'markers_repository' => (
    'is' => 'ro',
    'isa' => 'Markers::MarkerRepository',
);

#########################################################################
# Usage      : @files_ids = save_uploads($uploads_aref);
# Purpose    : save uploads to file storage and get ids of files
# Returns    : none
# Parameters : $marker_id - id of a marker to add images to
#               $uplads_aref array reference for Wev::Request::Upload
# Throws     : no exceptions
# Comments   : ???
# See Also   : n/a
sub save_upload(){
    my ($self, $marker_id, $uploads_aref) = @_;

    my @uploaded_files_ids = _save_to_store($uploads_aref);
    $self->markers_repository->add_images_to_marker($marker_id, \@uploaded_files_ids);
}

sub _save_to_store(){
    my ($self, $uploads_aref) =@_;

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