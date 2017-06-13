package SimpleMail::Mail::Infra::Sender::Sendmail;
use strict;
use warnings;
use utf8;

use Encode qw/encode/;

use Mouse;

extends 'SimpleMail::Mail::Infra::Sender';

has mail => (is => 'ro', isa => 'SimpleMail::Mail', required => 1);

override send_mail => sub {
    my ($self) = @_;

    my $mail = $self->{mail};

    # TODO: 環境変数でいじるのもダサいので後で直す
    my $sendmail_cmd = $ENV{SENDMAIL_MOCK} || '/usr/sbin/sendmail';

    open my $fh, '|-', "$sendmail_cmd -t -i" or die "sendmail error: $!";
    print $fh 'From: ' . $mail->email . "\n";
    print $fh 'To: ' . $mail->to . "\n";
    print $fh 'Subject: ' . $mail->subject . "\n";
    print $fh "Content-Transfer-Encoding: 7bit\n";
    print $fh "Content-type: text/plain;charset=\"ISO-2022-JP\"\n\n";
    print $fh encode('ISO-2022-JP', $mail->body);
};

no Mouse;
__PACKAGE__->meta->make_immutable;

1;

