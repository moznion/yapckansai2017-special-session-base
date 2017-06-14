package SimpleMail::Application;
use strict;
use warnings;
use utf8;
use feature qw/state/;
use parent 'Plack::Component';
use Log::Minimal;
use Plack::Request;
use Plack::Response;

use SimpleMail::Application::Router;

use Mouse;

has router => (is => 'ro', isa => 'SimpleMail::Application::Router', default => sub { SimpleMail::Application::Router->new });

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
        state $ise_res = $self->_internal_server_error_response;
        return $ise_res;
    }

    return $res->finalize;
}

sub _internal_server_error_response {
    my ($self) = @_;

    my $ise_res = Plack::Response->new(500);
    $ise_res->headers([ 'Content-Type' => 'text/html; charset=UTF-8' ]);
    $ise_res->body('500 Internal server error');
    return $ise_res->finalize;
}

1;

