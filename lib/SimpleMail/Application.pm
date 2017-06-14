package SimpleMail::Application;
use strict;
use warnings;
use utf8;
use feature qw/state/;
use parent 'Plack::Component';
use Log::Minimal;
use Plack::Request;

use SimpleMail::Application::Router;
use SimpleMail::Presentation::ExceptionalRenderer;

use Mouse;

has router => (
    is      => 'ro',
    isa     => 'SimpleMail::Application::Router',
    default => sub { SimpleMail::Application::Router->new },
);

no Mouse;
__PACKAGE__->meta->make_immutable;

sub call {
    my ($self, $env) = @_;

    my $req = Plack::Request->new($env);

    my $res;
    eval {
        $res = $self->router->dispatch($req);
    };
    if ($@) {
        Log::Minimal::warnf($@);
        $res = SimpleMail::Presentation::ExceptionalRenderer->render_internal_server_error;
    }

    return $res->finalize;
}

1;

