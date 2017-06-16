package SimpleMail::Mailing::Domain::DeliveringService;
use strict;
use warnings;
use utf8;
use feature qw/state/;
use Data::Validator;
use Encode qw/encode_utf8/;
use Log::Minimal;

use SimpleMail::Mailing::Infra::Sender::Sendmail;

use Mouse;

has mail_sender => (is => 'ro', isa => 'SimpleMail::Mailing::Domain::Sender', default => sub { SimpleMail::Mailing::Infra::Sender::Sendmail->new } );

no Mouse;
__PACKAGE__->meta->make_immutable;

sub deliver_mail {
    state $rule = Data::Validator->new(
        mail => { isa => 'SimpleMail::Mailing::Domain::Mail' },
    )->with('Method');

    my ($self, $args) = $rule->validate(@_);
    my $mail = $args->{mail};

    $self->mail_sender->send_mail($mail);
    $self->_log($mail);
}

sub _log {
    my ($self, $mail) = @_;
    Log::Minimal::infof("%s<>%s<>%s", encode_utf8($mail->name), encode_utf8($mail->email), encode_utf8($mail->msg));
}

1;

