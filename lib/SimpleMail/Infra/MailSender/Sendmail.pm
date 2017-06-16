package SimpleMail::Infra::MailSender::Sendmail;
use strict;
use warnings;
use utf8;

use Mouse;

extends 'SimpleMail::Domain::Service::MailSender';

override sendmail_cmd => sub { '/usr/sbin/sendmail' };

no Mouse;
__PACKAGE__->meta->make_immutable;

1;

