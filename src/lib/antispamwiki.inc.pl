######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'antispamwiki.inc.cgi'
######################################################################
#
# Wiki���ѥߥ��ɻ�
#
# JavaScript��cookie���Ѥ����ʰ�Ū�ʥ��ѥߥ��ɻߤǤ���
# ������������cookie�˵�Ͽ���ޤ���
# �ʲ��ξ��Ƕ���Ū��FrontPage�����Ф��ޤ�
# ������������狼��ͭ�����¤�ۤ�����
# ��$::form{mymsg} ��¸�ߤ��롢�ޤ��� POST�᥽�åɻ���
#   ͭ�����¤�ۤ������ޤ���cookie������ξ��
#
# �Ȥ�����
#   ��antispamwiki.inc.pl��antispamwiki.inc.cgi�˥�͡��ह������ǻȤ��ޤ�
#
######################################################################

# ͭ�����¡ʣ����֡�
$AntiSpamWiki::expire=1*60*60
	if(!defined($AntiSpamWiki::expire));
#
# ��û�񤭹��߻��֡ʣ��á�
$AntiSpamWiki::mintime=3
	if(!defined($AntiSpamWiki::mintime));
#
%::antispamwiki_cookie;
$::antispamwiki_cookie="PAW_"
				. &dbmname($::basepath);
$::antispamwiki_cookie_name="t";
$::antispamwiki_cookie_expire=60*60*60;
######################################################################

# Initlize												# comment

sub plugin_antispamwiki_init {

#	return('init'=>0)
#		if($::form{cmd}!~/edit|article|attach|bugtrack|comment|vote/);

	my $stat=0;
	%::antispamwiki_cookie=();
	%::antispamwiki_cookie=&getcookie($::antispamwiki_cookie,%::antispamwiki_cookie);
	my $time=time;
	if($::antispamwiki_cookie{$::antispamwiki_cookie_name} eq '') {
		$stat=1;
	} elsif($::antispamwiki_cookie{$::antispamwiki_cookie_name}+0+$AntiSpamWiki::expire < $time) {
		$stat=-1;
	} elsif($time-$::antispamwiki_cookie{$::antispamwiki_cookie_name}+0 < $AntiSpamWiki::mintime) {
		$stat=-1;
	}
$::debug.="now:$time, cookie:$::antispamwiki_cookie{$::antispamwiki_cookie_name}\n";
	if($stat+0 ne 0) {
		if($::form{mymsg} ne '' ||$::form{msg} ne '') {
			$::form{cmd}="read";
			$::form{mypage}=$::FrontPage;
		}
	}
	$::antispamwiki_cookie{$::antispamwiki_cookie_name}=$time;
	&setcookie($::antispamwiki_cookie,$::antispamwiki_cookie_expire,%::antispamwiki_cookie);

#	my $js=qq(<script type="text/javascript"><!--\nd.cookie="$::antispamwiki_cookie=$::antispamwiki_cookie_name%3a$time; path=$::basepath";\n//--></script>\n);

#	my $dmyform=<<EOM;

	return('init'=>1, 'func'=>'skinhead', 'skinhead'=>&skinhead);
#	return('init'=>1, 'header'=>$js);
}

1;
__DATA__
sub plugin_antispamwiki_setup {
	return(
		ja'=>'Wiki���ѥߥ��ɻ�',
		en=>'Anti Spam for WikiPlugin',
		override=>'',
		require=>'',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/antispamwiki/'
	);
}
__END__

=head1 NAME

antispamwiki.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Wiki spamming prevention plugin

=head1 DESCRIPTION

Wiki spamming is prevented in simple using cookie.

=head1 USAGE

rename to antispamwiki.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/antispamwiki

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/antispam/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/antispamwiki.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
