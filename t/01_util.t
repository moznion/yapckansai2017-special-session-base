use strict;
use warnings;
use utf8;
use FindBin;
use Cwd qw/abs_path/;

use SimpleMail::Util qw/base_dir/;

use Test::More;

subtest 'base_dir' => sub {
    subtest 'sould get base dir successfully' => sub {
        my $base_dir = base_dir '/';
        is $base_dir, abs_path("$FindBin::Bin/../");
    };
};

done_testing;

