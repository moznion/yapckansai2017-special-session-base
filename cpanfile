requires 'Data::Printer';
requires 'feature';
requires 'Plack';

# TODO remove me when kicking out cgi successfully! {{{
requires 'CGI::Emulate::PSGI';
requires 'CGI::Compile';
# }}}

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::WWW::Mechanize::PSGI';
}

