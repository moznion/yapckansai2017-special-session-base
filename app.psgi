use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";

use Plack::Builder;
use SimpleMail::Application;

my $app = SimpleMail::Application->new->to_app;

builder {
    mount '/' => $app;
};

