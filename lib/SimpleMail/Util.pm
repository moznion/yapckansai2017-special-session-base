package SimpleMail::Util;
use strict;
use warnings;
use utf8;
use File::Spec;

use parent 'Exporter';
our @EXPORT_OK = qw/base_dir/;

sub base_dir($) {
    my ($path) = @_;

    $path =~ s!::!/!g;
    if (my $libpath = $INC{"$path.pm"}) {
        $libpath =~ s!\\!/!g; # win32
        $libpath =~ s!(?:blib/)?lib/+$path\.pm$!!;
        File::Spec->rel2abs($libpath || './');
    } else {
        File::Spec->rel2abs('./');
    }
}

1;

