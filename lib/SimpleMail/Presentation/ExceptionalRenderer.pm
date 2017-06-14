package SimpleMail::Presentation::ExceptionalRenderer;
use strict;
use warnings;
use utf8;
use feature qw/state/;

sub render_internal_server_error {
    my ($class) = @_;

    state $res = $class->_internal_server_error_response;
    return $res;
}

sub render_not_found_error {
    my ($class) = @_;

    state $res = $class->_not_found_response;
    return $res;
}

sub _internal_server_error_response {
    my ($self) = @_;

    my $ise_res = Plack::Response->new(500);
    $ise_res->headers([ 'Content-Type' => 'text/html; charset=UTF-8' ]);
    $ise_res->body('500 Internal server error');
    return $ise_res;
}

sub _not_found_response {
    my ($self) = @_;

    my $not_found_res = Plack::Response->new(404);
    $not_found_res->headers([ 'Content-Type' => 'text/html; charset=UTF-8' ]);
    $not_found_res->body('404 Not found');
    return $not_found_res;
}

1;

