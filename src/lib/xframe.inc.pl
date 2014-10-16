######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'xframe.inc.cgi'
######################################################################
#
# �ե졼�಼��ɽ������ʤ��褦�ˤ���ץ饰����
# http://www.jpcert.or.jp/ed/2009/ed090001.pdf
#
######################################################################
#
# DENY:¾��Web�ڡ�����frame��ޤ���iframe��Ǥ�ɽ������ݤ��롣
# SAMEORIGIN:Top-level-browsing-context�����פ������Τߡ�¾��Web�ڡ���
#            ���frame����iframe��Ǥ�ɽ������Ĥ��롣

$XFRAME::MODE="DENY"
#$XFRAME::MODE="SAMEORIGIN"
	if(!defined($XFRAME::MODE));


# Initlize

sub plugin_xframe_init {
	my $agent=$ENV{HTTP_USER_AGENT};
	my $header;
	$header=<<EOM;
X-FRAME-OPTIONS: $XFRAME::MODE
EOM
	return ('http_header'=>$header, 'init'=>1, 'func'=>'');
}

1;
__DATA__
sub plugin_xframe_setup {
	return(
		ja=>'�ե졼�಼��ɽ������ʤ��褦�ˤ���ץ饰����',
		en=>'Disable view page on apper on the bottom frame',
		override=>'none',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/xframe/'
	);
}
__END__
=head1 NAME

xframe.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Disable view page on apper on the bottom frame

=head1 USAGE

rename to xframe.inc.cgi

=head1 SETTING

Write to info/setting.ini.cgi

$XFRAME::MODE="DENY" or $XFRAME::MODE="SAMEORIGIN"

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/xframe

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/xframe/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/xframe.inc.pl>

=item Refernce

L<http://www.jpcert.or.jp/ed/2009/ed090001.pdf>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
