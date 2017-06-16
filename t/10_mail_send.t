use strict;
use warnings;
use utf8;
use Encode qw/encode/;
use FindBin;

use SimpleMail::Mailing::Domain::Mail;
use SimpleMail::Mailing::Domain::DeliveringService;
use SimpleMail::Mailing::Infra::Sender::SendmailMock;

use Test::More;

my $log_file = "$FindBin::Bin/../devtools/sendmail_mock.log";
unlink $log_file;

subtest 'should send mail successfully' => sub {
    my $mail = SimpleMail::Mailing::Domain::Mail->new(
        name  => 'moznion',
        email => 'moznion@gmail.com',
        msg   => 'Hello',
    );

    my $mail_delivering_service = SimpleMail::Mailing::Domain::DeliveringService->new(
        mail_sender => SimpleMail::Mailing::Infra::Sender::SendmailMock->new,
    );
    $mail_delivering_service->deliver_mail({mail => $mail});

    my $body = $mail->body;
    my $encoded_body = encode('ISO-2022-JP', $body);

    open my $fh, '<', $log_file;
    my $mail_content = do { local $/; <$fh> };
    is $mail_content, "-t\n-i\nFrom: moznion\@gmail.com\nTo: moznion\@gmail.com\nSubject: mail_form\nContent-Transfer-Encoding: 7bit\nContent-type: text/plain;charset=\"ISO-2022-JP\"\n\n$encoded_body", 'Mail contet is valid';
};

done_testing;

