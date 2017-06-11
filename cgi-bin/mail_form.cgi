#!/usr/bin/env perl
require './cgi-lib.pl';
require './jcode.pl';

{
    local (*cgi_input);
    &ReadParse(*cgi_input);
    %in = %cgi_input;
}

$name    = $in{name};
$email   = $in{email};
$msg     = $in{msg};
$comfirm = $in{comfirm};

print &PrintHeader;
print &HtmlTop('メールフォーム');

if (&MethPost) {

    # POSTの場合
    $html = <<"HTML";
<table>
    <tr>
        <td align="right">お名前：</td>
        <td>$name</td>
    </tr>
    <tr>
        <td align="right">メールアドレス：</td>
        <td>$email</td>
    </tr>
    <tr>
        <td align="right">メッセージ：</td>
        <td>$msg</td>
    </tr>
</table>
HTML
    if ($comfirm) {

        # 確認モード

        # 値の確認
        @errors = ();

        # 名前
        if (length $name < 1) {
            push @errors, 'お名前を入力してください';
        }

        # メールアドレス
        if (length $email < 1) {
            push @errors, 'メールアドレスを入力してください';
        }
        elsif ($email !~ /^[^@]+@[^@]+$/) {
            push @errors, 'メールアドレスを正しく入力してください';
        }

        # メッセージ
        if (length $msg < 1) {
            push @errors, 'メッセージを入力してください';
        }

        # エラーがあれば表示して終了
        if (@errors) {
            &print_form(@errors);
            exit;
        }

        # HTMLレスポンス
        print <<"HTML";
<h2>送信内容を確認してください</h2>
HTML
        print $html;
        print <<"HTML";
<table>
    <tr>
        <td>
            <form action="./mail_form.cgi" method="POST" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="name" value="$name">
                <input type="hidden" name="email" value="$email">
                <input type="hidden" name="msg" value="$msg">
                <input type="submit" value="送信する">
            </form>
        </td>
        <td>
            <form action="./mail_form.cgi" method="GET" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="name" value="$name">
                <input type="hidden" name="email" value="$email">
                <input type="hidden" name="msg" value="$msg">
                <input type="submit" value="修正する">
            </form>
        </td>
    </tr>
</table>
HTML
        print &HtmlBot;
    }
    else {
        # 送信モード

        # メール送信
        $to      = 'nqou.net@gmail.com';
        $subject = 'mail_form';
        $body    = <<"BODY";
お名前　　　　： $name
メールアドレス： $email
メッセージ　　： $msg
BODY
        $sendmail_cmd = '/usr/sbin/sendmail';
        open(MAIL, "| $sendmail_cmd -t -i") || die 'sendmail error';
        print MAIL "From: $email\n";
        print MAIL "To: $to\n";
        print MAIL "Subject: $subject\n";
        print MAIL "Content-Transfer-Encoding: 7bit\n";
        print MAIL "Content-type: text/plain;charset=\"ISO-2022-JP\"\n\n";
        &jcode::convert(\$body, 'jis');
        print MAIL "$body";
        close(MAIL);

        # ログファイルに残す
        $log = "$name<>$email<>$msg";
        open(FILE, '>> mail_form.log') || die 'file error';
        print FILE "$log\n";
        close(FILE);

        # HTMLレスポンス
        print <<"HTML";
<h2>以下の内容で送信しました</h2>
HTML
        print $html;
        print <<"HTML";
<p>ありがとうございました</p>
<p><a href="./mail_form.cgi">トップへ戻る</a></p>
HTML
        print &HtmlBot;
    }
}
else {
    # GETの場合
    &print_form;
}

# フォームを表示する
sub print_form {
    if (@_) {
        foreach (@_) {
            print <<HTML;
<p><font color="red">$_</font></p>
HTML
        }
    }
    print <<"HTML";
<form action="./mail_form.cgi" method="POST" enctype="application/x-www-form-urlencoded">
    <input type="hidden" name="comfirm" value="1">
    <table>
        <tr>
            <td align="right">お名前：</td>
            <td><input type="text" name="name" size="30" value="$name"></td>
        </tr>
        <tr>
            <td align="right">メールアドレス：</td>
            <td><input type="text" name="email" size="30" value="$email"></td>
        </tr>
        <tr>
            <td align="right">メッセージ：</td>
            <td><textarea name="msg" rows="10" cols="80">$msg</textarea></td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                <input type="submit" value="送信内容を確認する">
            </td>
            <td>
                <input type="reset" value="リセット">
            </td>
        </tr>
    </table>
</form>
HTML
    print &HtmlBot;
}
