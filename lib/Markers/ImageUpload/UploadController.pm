package Markers::ImageUpload::UploadController;
use Moose;
use JSON;

has 'upload_service' => (
    'is' => 'ro',
    'isa' => 'Markers::ImageUpload::UploadService',
    'required' => 1,
);



sub process_upload(){
    my ($self, $request) = @_;

    my $uploads_href = $request->all_uploads();
    my $marker_id = $request->param('marker_id');
    my @images_urls = ();
    if(exits($uploads_href->{'file'})){
        @images_urls = $self->upload_service->save( $uploads_href->{'file'} );
    }

    return JSON->new()->encode(\@images_urls);
}

1;