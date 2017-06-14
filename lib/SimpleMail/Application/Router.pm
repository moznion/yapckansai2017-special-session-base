package SimpleMail::Application::Router;
use strict;
use warnings;
use utf8;
use feature qw/state/;
use Router::Boom::Method;
use Plack::Response;

use SimpleMail::Application::Controller; # XXX 本当はもっとやりようがある!

use Mouse;

has router           => (is => 'ro', isa => 'Router::Boom::Method', builder => '_build_router');
has controller_cache => (is => 'ro', isa => 'HashRef', default => sub { +{} });

no Mouse;
__PACKAGE__->meta->make_immutable;

sub _build_router {
    my ($self) = @_;

    my $r = Router::Boom::Method->new();

    $r->add('GET', '/new',     ['SimpleMail::Application::Controller', 'new_page']);
    $r->add('GET', '/confirm', ['SimpleMail::Application::Controller', 'confirm_page']);
    $r->add('GET', '/sent',    ['SimpleMail::Application::Controller', 'sent_page']);

    $r->add('POST', '/new', ['SimpleMail::Application::Controller', 'receive_mail_content']);
    $r->add('POST', '/mail', ['SimpleMail::Application::Controller', 'send_mail']);

    return $r;
}

sub dispatch {
    # $req: Plack::Request
    my ($self, $req) = @_;

    my ($dst, $captured) = $self->router->match($req->method, $req->path_info);
    unless ($dst) {
        # 404
        state $not_found_res = $self->_not_found_response;
        return $not_found_res;
    }

    my $controller = $self->_determine_controller($dst);
    my $method = $self->_determine_method($dst);

    # Return: Plack::Response
    return $controller->$method($req);
}

sub _determine_controller {
    my ($self, $dst) = @_;

    my $controller_class = $dst->[0];
    my $controller = $self->controller_cache->{$controller_class};
    unless ($controller) {
        $controller = $controller_class->new;
        $self->controller_cache->{$controller_class} = $controller;
    }

    return $controller;
}

sub _determine_method {
    my ($self, $dst) = @_;

    return $dst->[1];
}

sub _not_found_response {
    my ($self) = @_;

    my $not_found_res = Plack::Response->new(404);
    $not_found_res->headers([ 'Content-Type' => 'text/html; charset=UTF-8' ]);
    $not_found_res->body('404 Not found');
    return $not_found_res->finalize;
}

1;

