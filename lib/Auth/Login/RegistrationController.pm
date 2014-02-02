package Auth::Login::RegistrationController;

use Moose;
use JSON;

use Auth::UserRepository;
use Auth::User;

has 'user_repository' => (
    'is'  => 'ro',
    'isa' => 'Auth::UserRepository',
    'required' => 1,
);

sub register_user(){
    my ($self, $request) = @_;
    my $user_json_string =  $request->content;

    my $user_json = JSON->new->decode($marker_json_string);
    my $marker_to_save = $self->_hash_to_marker($marker_json);

    my $saved_marker = $self->markers_repository->save_marker($marker_to_save);
    return JSON->new->encode($self->_marker_to_hash($saved_marker));
}

sub hash_to_user(){
    my ($self, $user_hash) = @_;

    $user = Auth::User->new(
        'login' => $user_hash->{'login'},
        'email' => $user_hash->{'email'},
        'friendly_name' => $user_hash->{'friendly_name'},
        'provider' => 'internal',
    );
}
