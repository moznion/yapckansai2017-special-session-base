#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use FindBin;

# sendmailのmock．
# コマンドライン引数越しに与えられたコンテンツをログに記録して,そのファイルパスを返す.

my $log_location = $ENV{SENDMAIL_MOCK_LOG_LOCATION} || "$FindBin::Bin/sendmail_mock.log";
open my $fh, '>', $log_location; # NOTE: このコマンドが起動される度にlogファイルの中身はクリーンされることに注意

print $fh join "\n", @ARGV;
print $fh "\n";

while (my $line = <STDIN>) {
    print $fh $line;
}

__END__

