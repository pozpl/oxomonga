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
    my @images_urls = ();
    if(exits($uploads_href->{'up_image'})){
        @images_urls = $self->upload_service->save( $uploads_href->{'up_image'} );
    }

    return JSON->new()->encode(\@images_urls);
}

1;