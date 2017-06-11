use strict;
use warnings;
use utf8;
use Plack::Builder;
use Plack::App::WrapCGI;

builder {
    mount "/mail_form.cgi" => Plack::App::WrapCGI->new(script => './cgi-bin/mail_form.utf8.cgi', execute => 1)->to_app;
};

