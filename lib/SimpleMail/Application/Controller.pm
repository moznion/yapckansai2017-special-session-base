package SimpleMail::Application::Controller;
use strict;
use warnings;
use utf8;

use constant {
    TITLE => 'メールフォーム',
};

use Encode qw/decode_utf8/;
use FormValidator::Lite qw/Email/;
use URI;

use SimpleMail::Presentation::HtmlRenderer;
use SimpleMail::Mailing::Domain::Mail;
use SimpleMail::Mailing::Domain::DeliveringService;
use SimpleMail::Mailing::Infra::Sender::SendmailMock;

use Mouse;

has html_renderer => (
    is      => 'ro',
    isa     => 'SimpleMail::Presentation::HtmlRenderer',
    default => sub { SimpleMail::Presentation::HtmlRenderer->new },
);

has mail_delivering_service => (
    is => 'ro',
    isa => 'SimpleMail::Mailing::Domain::DeliveringService',
    default => sub {
        SimpleMail::Mailing::Domain::DeliveringService->new(
            # XXX 機能テスト用．スマートじゃない！！！
            $ENV{USE_SENDMAIL_MOCK} ? (mail_sender => SimpleMail::Mailing::Infra::Sender::SendmailMock->new) : (),
        );
    },
);

no Mouse;
__PACKAGE__->meta->make_immutable;

sub new_page {
    my ($self, $req) = @_;

    my @errors = map { decode_utf8($_) } $req->query_parameters->get_all('error');

    return $self->html_renderer->render('form.mt', {
        title  => TITLE,
        name   => decode_utf8($req->param('name')) || '',
        email  => decode_utf8($req->param('email')) || '',
        msg    => decode_utf8($req->param('msg')) || '',
        errors => \@errors,
    });
}

sub receive_mail_content {
    my ($self, $req) = @_;

    my $validator = FormValidator::Lite->new($req);
    my $result = $validator->check(
        name  => [qw/NOT_NULL/],
        email => [qw/NOT_NULL EMAIL/],
        msg   => [qw/NOT_NULL/],
    );

    my $param = $req->parameters;
    my $res = Plack::Response->new();

    if ($validator->has_error) {
        # TODO: form validation周りはpolicyレイヤに追い出すのが良さそう
        my $form_errors = $validator->errors;

        my @errors;
        push @errors, 'お名前を入力してください'               if $form_errors->{name}->{NOT_NULL};
        push @errors, 'メールアドレスを入力してください'       if $form_errors->{email}->{NOT_NULL};
        push @errors, 'メールアドレスを正しく入力してください' if $form_errors->{email}->{EMAIL};
        push @errors, 'メッセージを入力してください'           if $form_errors->{msg}->{NOT_NULL};

        my $uri = URI->new('/new');
        $uri->query_form(
            name  => decode_utf8($param->{name}),
            email => decode_utf8($param->{email}),
            msg   => decode_utf8($param->{msg}),
            error => \@errors,
        );
        $res->redirect($uri->as_string);
        return $res;
    }

    my $uri = URI->new('/confirm');
    $uri->query_form(
        name  => decode_utf8($param->{name}),
        email => decode_utf8($param->{email}),
        msg   => decode_utf8($param->{msg}),
    );
    $res->redirect($uri);
    return $res;
}

sub confirm_page {
    my ($self, $req) = @_;

    return $self->html_renderer->render('confirm.mt', {
        title  => TITLE,
        name   => decode_utf8($req->param('name')) || '',
        email  => decode_utf8($req->param('email')) || '',
        msg    => decode_utf8($req->param('msg')) || '',
    });
}

sub send_mail {
    my ($self, $req) = @_;

    my $param = $req->parameters;

    my $mail = SimpleMail::Mailing::Domain::Mail->new(
        name  => decode_utf8($param->{name}),
        email => decode_utf8($param->{email}),
        msg   => decode_utf8($param->{msg}),
    );
    $self->mail_delivering_service->deliver_mail({mail => $mail});

    my $res = Plack::Response->new();

    my $uri = URI->new('/sent');
    $uri->query_form(
        name  => decode_utf8($param->{name}),
        email => decode_utf8($param->{email}),
        msg   => decode_utf8($param->{msg}),
    );
    $res->redirect($uri);

    return $res;
}

sub sent_page {
    my ($self, $req) = @_;

    return $self->html_renderer->render('sent.mt', {
        title  => TITLE,
        name   => decode_utf8($req->param('name')) || '',
        email  => decode_utf8($req->param('email')) || '',
        msg    => decode_utf8($req->param('msg')) || '',
    });
}

1;

