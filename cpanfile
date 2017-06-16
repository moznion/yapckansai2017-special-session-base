requires 'Plack';
requires 'Mouse';
requires 'Data::Validator';
requires 'Log::Minimal';
requires 'FormValidator::Lite';
requires 'Router::Boom';
requires 'Text::MicroTemplate';
requires 'Path::Tiny';
requires 'URI';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::WWW::Mechanize::PSGI';
};

on 'develop' => sub {
    requires 'Perl::Critic';
    requires 'Test::Perl::Critic';
};

