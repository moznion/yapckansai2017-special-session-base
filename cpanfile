requires 'Data::Printer';
requires 'feature';
requires 'Plack';
requires 'Mouse';
requires 'Log::Minimal';
requires 'FormValidator::Lite';
requires 'Router::Boom';
requires 'Text::MicroTemplate';
requires 'Path::Tiny';
requires 'URI';

# TODO remove me when kicking out cgi successfully! {{{
requires 'CGI::Emulate::PSGI';
requires 'CGI::Compile';
# }}}

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::WWW::Mechanize::PSGI';
}

