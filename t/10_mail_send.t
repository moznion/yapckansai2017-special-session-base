use strict;
use warnings;
use utf8;
use Encode qw/encode/;
use FindBin;

use SimpleMail::Mail;

use Test::More;

local $ENV{SENDMAIL_MOCK} = "perl $FindBin::Bin/../devtools/sendmail_mock.pl";

subtest 'should send mail successfully' => sub {
    my $mail = SimpleMail::Mail->new(
        name  => 'moznion',
        email => 'moznion@gmail.com',
        msg   => 'Hello',
    );

    $mail->send;

    my $body = $mail->body;
    my $encoded_body = encode('ISO-2022-JP', $body);

    open my $fh, '<', "$FindBin::Bin/../devtools/sendmail_mock.log";
    my $mail_content = do { local $/; <$fh> };
    is $mail_content, "-t\n-i\nFrom: moznion\@gmail.com\nTo: moznion\@gmail.com\nSubject: mail_form\nContent-Transfer-Encoding: 7bit\nContent-type: text/plain;charset=\"ISO-2022-JP\"\n\n$encoded_body", 'Mail contet is valid';
};

done_testing;

