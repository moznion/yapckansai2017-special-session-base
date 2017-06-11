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
print &HtmlTop('���[���t�H�[��');

if (&MethPost) {

    # POST�̏ꍇ
    $html = <<"HTML";
<table>
    <tr>
        <td align="right">�����O�F</td>
        <td>$name</td>
    </tr>
    <tr>
        <td align="right">���[���A�h���X�F</td>
        <td>$email</td>
    </tr>
    <tr>
        <td align="right">���b�Z�[�W�F</td>
        <td>$msg</td>
    </tr>
</table>
HTML
    if ($comfirm) {

        # �m�F���[�h

        # �l�̊m�F
        @errors = ();

        # ���O
        if (length $name < 1) {
            push @errors, '�����O����͂��Ă�������';
        }

        # ���[���A�h���X
        if (length $email < 1) {
            push @errors, '���[���A�h���X����͂��Ă�������';
        }
        elsif ($email !~ /^[^@]+@[^@]+$/) {
            push @errors, '���[���A�h���X�𐳂������͂��Ă�������';
        }

        # ���b�Z�[�W
        if (length $msg < 1) {
            push @errors, '���b�Z�[�W����͂��Ă�������';
        }

        # �G���[������Ε\�����ďI��
        if (@errors) {
            &print_form(@errors);
            exit;
        }

        # HTML���X�|���X
        print <<"HTML";
<h2>���M���e���m�F���Ă�������</h2>
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
                <input type="submit" value="���M����">
            </form>
        </td>
        <td>
            <form action="./mail_form.cgi" method="GET" enctype="application/x-www-form-urlencoded">
                <input type="hidden" name="name" value="$name">
                <input type="hidden" name="email" value="$email">
                <input type="hidden" name="msg" value="$msg">
                <input type="submit" value="�C������">
            </form>
        </td>
    </tr>
</table>
HTML
        print &HtmlBot;
    }
    else {
        # ���M���[�h

        # ���[�����M
        $to      = 'nqou.net@gmail.com';
        $subject = 'mail_form';
        $body    = <<"BODY";
�����O�@�@�@�@�F $name
���[���A�h���X�F $email
���b�Z�[�W�@�@�F $msg
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

        # ���O�t�@�C���Ɏc��
        $log = "$name<>$email<>$msg";
        open(FILE, '>> mail_form.log') || die 'file error';
        print FILE "$log\n";
        close(FILE);

        # HTML���X�|���X
        print <<"HTML";
<h2>�ȉ��̓��e�ő��M���܂���</h2>
HTML
        print $html;
        print <<"HTML";
<p>���肪�Ƃ��������܂���</p>
<p><a href="./mail_form.cgi">�g�b�v�֖߂�</a></p>
HTML
        print &HtmlBot;
    }
}
else {
    # GET�̏ꍇ
    &print_form;
}

# �t�H�[����\������
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
            <td align="right">�����O�F</td>
            <td><input type="text" name="name" size="30" value="$name"></td>
        </tr>
        <tr>
            <td align="right">���[���A�h���X�F</td>
            <td><input type="text" name="email" size="30" value="$email"></td>
        </tr>
        <tr>
            <td align="right">���b�Z�[�W�F</td>
            <td><textarea name="msg" rows="10" cols="80">$msg</textarea></td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                <input type="submit" value="���M���e���m�F����">
            </td>
            <td>
                <input type="reset" value="���Z�b�g">
            </td>
        </tr>
    </table>
</form>
HTML
    print &HtmlBot;
}
