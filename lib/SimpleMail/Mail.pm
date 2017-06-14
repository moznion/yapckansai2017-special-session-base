package SimpleMail::Mail;
use strict;
use warnings;
use utf8;
use Log::Minimal;

use SimpleMail::Mail::Infra::Sender::Sendmail;

use Mouse;

has name        => (is => 'ro', isa => 'Str', required => 1);
has email       => (is => 'ro', isa => 'Str', required => 1);
has msg         => (is => 'ro', isa => 'Str', required => 1);
has to          => (is => 'ro', isa => 'Str', default => 'moznion@gmail.com');
has subject     => (is => 'ro', isa => 'Str', default => 'mail_form');
has body        => (is => 'ro', isa => 'Str', lazy_build => 1);
has mail_sender => (is => 'ro', isa => 'SimpleMail::Mail::Infra::Sender', default => sub { SimpleMail::Mail::Infra::Sender::Sendmail->new } );

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

sub send {
    my ($self) = @_;

    $self->mail_sender->send_mail($self);
    $self->_log;
}

sub _log {
    my ($self) = @_;
    Log::Minimal::infof("%s<>%s<>%s", $self->name, $self->email, $self->msg);
}

1;

