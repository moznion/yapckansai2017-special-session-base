package SimpleMail::Mailing::Domain::Sender;
use strict;
use warnings;
use utf8;

use Encode qw/encode/;

use Mouse;

no Mouse;
__PACKAGE__->meta->make_immutable;

sub sendmail_cmd;

sub send_mail {
    my ($self, $mail) = @_;

    my $sendmail_cmd = $self->sendmail_cmd;

    open my $fh, '|-', "$sendmail_cmd -t -i" or die "sendmail error: $!";
    print $fh 'From: ' . $mail->email . "\n";
    print $fh 'To: ' . $mail->to . "\n";
    print $fh 'Subject: ' . $mail->subject . "\n";
    print $fh "Content-Transfer-Encoding: 7bit\n";
    print $fh "Content-type: text/plain;charset=\"ISO-2022-JP\"\n\n";
    print $fh encode('ISO-2022-JP', $mail->body);
};

1;

