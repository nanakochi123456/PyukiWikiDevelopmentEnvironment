######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'xframe.inc.cgi'
######################################################################
#
# フレーム下に表示されないようにするプラグイン
# http://www.jpcert.or.jp/ed/2009/ed090001.pdf
#
######################################################################
#
# DENY:他のWebページのframe上またはiframe上での表示を拒否する。
# SAMEORIGIN:Top-level-browsing-contextが一致した時のみ、他のWebページ
#            上のframe又はiframe上での表示を許可する。

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
		ja=>'フレーム下に表示されないようにするプラグイン',
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
