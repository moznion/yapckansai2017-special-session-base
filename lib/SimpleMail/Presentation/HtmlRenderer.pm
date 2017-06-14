package SimpleMail::Presentation::HtmlRenderer;
use strict;
use warnings;
use utf8;
use Encode qw/encode_utf8/;
use Path::Tiny qw/path/;
use Plack::Response;
use Text::MicroTemplate::File;

use SimpleMail::Util qw/base_dir/;

use Mouse;

has micro_template => (is => 'ro', isa => 'Text::MicroTemplate::File', builder => '_build_micro_template');

no Mouse;
__PACKAGE__->meta->make_immutable;

sub _build_micro_template {
    my ($self) = @_;

    return Text::MicroTemplate::File->new(
        include_path => [path(base_dir('/'), 'templates')->absolute],
        use_cache    => 1,
    );
}

sub render {
    my ($self, $template_file, $args) = @_;

    my $rendered = encode_utf8($self->micro_template->render_file($template_file, $args));

    my $res = Plack::Response->new(200);
    $res->headers([ 'Content-Type' => 'text/html; charset=UTF-8' ]);
    $res->body($rendered);

    return $res;
}

1;

