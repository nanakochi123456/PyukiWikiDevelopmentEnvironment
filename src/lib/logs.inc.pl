######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'logs.inc.cgi'
######################################################################

# ディレクトリ
$logs::directory="$::data_home/logs"
	if(!defined($logs::directory));

# 圧縮保存
$logs::compress=0
	if(!defined($logs::compress));

$logs::refresh=1
	if(!defined($linktrack::refresh));

$logs::date_format="Y-m-d D"
	if(!defined($logs::date_format));
$logs::time_format="H:i:s"
	if(!defined($logs::time_format));

######################################################################

use strict;
use Nana::YukiWikiDB;
use Nana::YukiWikiDB_GZIP;

%::logbase;

@logs::allowcmd=(
	"read",
	"write",
	"article:POST",
	"comment:POST",
	"pcomment:POST",
	"attach",
	"bugtrack:POST",
	"adminedit:POST",
	"edit:POST",
	"vote:POST",
	"search:POST",
);

# Initlize														# comment

sub plugin_logs_init {
	&exec_explugin_sub("lang");
	&exec_explugin_sub("authadmin_cookie");
	&exec_explugin_sub("urlhack");
	&plugin_logs_do($::form{cmd}, $::form{mypage});
	return('init'=>1);
}

sub plugin_logs_do {
	my($cmd, $page)=@_;
	my $flg=0;
	foreach(@logs::allowcmd) {
		my ($t,$m)=split(/:/,$_);
		$flg=1 if($cmd eq $t && $m eq "");
		$flg=1 if($cmd eq $t && $m eq "POST" && $ENV{REQUEST_METHOD} eq "POST");
	}
	return if($flg eq 0);

	if($cmd eq "attach") {
		$cmd="$cmd-$::form{pcmd}";
		$page="$page<>$::form{file}";
	} elsif($cmd eq "search") {
		$page="$::form{type}<>$::form{mymsg}";
	}

	return if($page eq '');

	my $filename=&date("Y-m-d");
	&getremotehost;
	my $user=$::authadmin_cookie_user_name;

	my $logtxt=<<EOM;
$ENV{REMOTE_HOST} $ENV{REMOTE_ADDR}\t@{[&date($logs::date_format)]} @{[&date($logs::time_format)]}\t$user\t$ENV{REQUEST_METHOD}\t$cmd\t$::lang\t$page\t$ENV{HTTP_USER_AGENT}\t$ENV{HTTP_REFERER}
EOM
	&plugin_logs_add($filename, $logtxt);
}

sub plugin_logs_add {
	my ($filename, $text)=@_;

	my $err;
	my $err=&writechk($logs::directory);
	if($err ne '') {
		&print_error($err);
		exit;
	}

	if($logs::compress eq 1) {
		&dbopen_gz($logs::directory,\%::logbase);
	} else {
		&dbopen($logs::directory,\%::logbase);
	}
	$::logbase{$filename}.=$text;
	&dbclose(\%::logbase);
}

1;
__DATA__
	return(
		ja=>'アクセスログ取得',
		en=>'Take access log',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/logs/'
	);
__END__

=head1 NAME

logs.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Take access log

=head1 DESCRIPTION

Taking access log

=head1 USAGE

=head2 Enable plugin

Rename to logs.inc.cgi

Make directory ./logs (default)

=head1 SETTING

=over 4

=item $logs::compress

If you have heavy site, change value to 0

=item $logs::directory

Setting  access log directory

=back

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/logs

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/logs/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/logs.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Logs.pm>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/logs_viewer.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/AWS/browsers.pm>

L<@@CVSURL@@/PyukiWiki-Devel/lib/AWS/domains.pm>

L<@@CVSURL@@/PyukiWiki-Devel/lib/AWS/operating_systems.pm>

L<@@CVSURL@@/PyukiWiki-Devel/lib/AWS/robots.pm>

L<@@CVSURL@@/PyukiWiki-Devel/lib/AWS/search_engines.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
