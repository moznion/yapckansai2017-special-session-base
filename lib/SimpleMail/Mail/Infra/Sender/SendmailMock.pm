package SimpleMail::Mail::Infra::Sender::SendmailMock;
use strict;
use warnings;
use utf8;

use SimpleMail::Util qw/base_dir/;

use Mouse;

extends 'SimpleMail::Mail::Infra::Sender';

override sendmail_cmd => sub { sprintf 'perl %s/devtools/sendmail_mock.pl', base_dir('/') };

no Mouse;
__PACKAGE__->meta->make_immutable;

1;
