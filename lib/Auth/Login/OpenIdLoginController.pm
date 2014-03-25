package Auth::Login::OpenIdLoginController;

use Moose;
use Cache::File;
use LWPx::ParanoidAgent;
use Net::OpenID::Consumer;
use Readonly;
use URI::Escape;


has 'CONSUMER_SECRET' => (
    is => 'ro',
    isa => 'String',
    default => <<'EOQ';
Scissors cuts paper, paper covers rock, rock crushes lizard, lizard poisons Spock, Spock smashes scissors, scissors decapitates lizard, lizard eats paper, paper disproves Spock, Spock vaporizes rock, and as it always has, rock crushes scissors.
EOQ
);

has 'CACHE_ROOT' => (
    is => 'ro',
    isa => 'String',
    default => '/tmp/cache',
);

#app->secret(
#    q{If you don't mind, I'd like to stop listening to you and start talking.}
#);

sub login(){
    my {$self, $request }= @_;

#    my %params = @{ $self->req->params->params };

    my $my_url = $request->base_uri->as_string;

    my $cache = Cache::File->new( cache_root => $self->CACHE_ROOT );
    my $csr = Net::OpenID::Consumer->new(
        ua              => LWPx::ParanoidAgent->new,
        cache           => $cache,
        args            => \%params,
        consumer_secret => $self->CONSUMER_SECRET,
        required_root   => $my_url
    );

    my $user_identity_site_url = $request->params('identity_site');

    my $claimed_identity = $csr->claimed_identity($user_identity_site_url);

    $claimed_identity->set_extension_args(
      "http://openid.net/srv/ax/1.0",
      {
        mode              => 'fetch_request',
        required          => 'email,firstname,lastname,country',
        'type.email'      => 'http://axschema.org/contact/email',
        'type.firstname'  => 'http://axschema.org/namePerson/first',
        'type.lastname'   => 'http://axschema.org/namePerson/last',
        'type.country'    => "http://axschema.org/contact/country/home",

        'ns.ui'         => 'http://specs.openid.net/extensions/ui/1.0',
        'ui.mode'       => 'popup'
      }
    );


    my openid_return = $request->uri_for('name' => 'openid_return');
    my $check_url = $claimed_identity->check_url(
        return_to      => qq{$my_url/} . openid_return,
        trust_root     => qq{$my_url/},
        delayed_return => 1,
    );

    return $self->redirect_to($check_url);
};

sub openid_return() {
    my ($self, $request) = @_;

    my $my_url = $request->base_uri->as_string;

    my %params = $request->parameters;
    while ( my ( $k, $v ) = each %params ) {
        $params{$k} = URI::Escape::uri_unescape($v);
    }

    my $cache = Cache::File->new( cache_root => $CACHE_ROOT );
    my $csr = Net::OpenID::Consumer->new(
        ua              => LWPx::ParanoidAgent->new,
        cache           => $cache,
        args            => \%params,
        consumer_secret => $CONSUMER_SECRET,
        required_root   => $my_url
    );

    my $msg = q{NO response?};

    $csr->handle_server_response(
        not_openid => sub {
            die "Not an OpenID message";
        },
        setup_required => sub {
            my $setup_url = shift;

            # Redirect the user to $setup_url
            $msg = qq{require setup [$setup_url]};

            $setup_url = URI::Escape::uri_unescape($setup_url);
            app->log->debug(qq{setup_url[$setup_url]});

            $msg = q{};
            return $self->redirect_to($setup_url);
        },
        cancelled => sub {

            # Do something appropriate when the user hits "cancel" at the OP
            $msg = 'cancelled';
        },
        verified => sub {
            my $vident = shift;

            my $ax_response = $vident->signed_extension_fields(
              "http://openid.net/srv/ax/1.0"
            );
            # Do something with the VerifiedIdentity object $vident
            $msg = 'verified';
            use Data::Dumper;
            $msg .= Dumper $ax_response;
        },
        error => sub {
            my $err = shift;

            app->log->error($err);

            die($err);
        },
    );
    $self->render( text => $msg ) if $msg ne q{};
};

app->start;

__DATA__