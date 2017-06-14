use strict;
use warnings;
use utf8;
use Encode qw/encode/;
use FindBin;
use Plack::Util;
use HTTP::Request;

use Test::More;
use Plack::Test;
use Test::WWW::Mechanize::PSGI;

local $ENV{USE_SENDMAIL_MOCK} = 1;

my $log_file = "$FindBin::Bin/../devtools/sendmail_mock.log";
unlink $log_file;

subtest 'should pass payload of mail to sendmail (mock) successfully ' => sub {
    my $app = Plack::Util::load_psgi("$FindBin::Bin/../app.psgi");

    my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);

    $mech->get_ok('/new');

    $mech->title_is('メールフォーム');

    subtest 'editing page' => sub {
        $mech->content_like(qr/メールフォーム/);

        $mech->submit_form_ok({
            form_number => 1,
            fields      => {
                name  => 'moznion',
                email => 'moznion@gmail.com',
                msg   => "Hello\nYo!",
            },
        });
    };

    subtest 'confirmation page' => sub {
        $mech->content_like(qr/送信内容を確認してください/);
        $mech->has_tag('td', 'moznion');
        $mech->has_tag('td', 'moznion@gmail.com');
        $mech->has_tag('td', "Hello Yo!"); # XXX ??? 改行どこいったんだ? よくわからんので後で調査

        $mech->submit_form_ok({
            form_number => 1, # 送信するボタン
        });
    };

    subtest 'sent page' => sub {
        $mech->content_like(qr/以下の内容で送信しました/);

        open my $fh, '<', $log_file;
        my $mail_content = do { local $/; <$fh> };
        like $mail_content, qr/-t\n-i\nFrom: moznion[@]gmail[.]com\nTo: moznion[@]gmail[.]com\nSubject: mail_form\nContent-Transfer-Encoding: 7bit\nContent-type: text\/plain;charset="ISO-2022-JP"/, 'Mail contet is valid';
    };
};

done_testing;

