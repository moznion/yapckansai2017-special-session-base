package SimpleMail::Mailing::Domain::Mail;
use strict;
use warnings;
use utf8;

use Mouse;

has name    => (is => 'ro', isa => 'Str', required   => 1);
has email   => (is => 'ro', isa => 'Str', required   => 0);
has msg     => (is => 'ro', isa => 'Str', required   => 0);
has to      => (is => 'ro', isa => 'Str', default    => 'moznion@gmail.com');
has subject => (is => 'ro', isa => 'Str', default    => 'mail_form');
has body    => (is => 'ro', isa => 'Str', lazy_build => 0);

no Mouse;
__PACKAGE__->meta->make_immutable;

sub _build_body {
    my ($self) = @_;

    return sprintf(<<'BODY', $self->name, $self->email, $self->msg);
お名前　　　　： %s
メールアドレス： %s
メッセージ　　： %s
BODY
}

1;

