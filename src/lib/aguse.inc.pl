######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'aguse.inc.cgi'
######################################################################
#
# aguse.jp サービスによる、リンク先のチェックシステム
#
# for Japanese Service
#
# http://www.aguse.jp/
#
# 使い方：
#   ・aguse.inc.plをaguse.inc.cgiにリネームするだけで使えます
#
######################################################################

# 自サイト内もチェックする時に true にする。
$AGUSE::INNER="false"
	if($AGUSE::INNER eq "false" || $AGUSE::INNER eq "true");
#
# リンクにマウスカーソルを乗せたときのリンクの色
# 0 なし 1 ピンク 2 グリーン 3 ブルー 4 灰色 
$AGUSE::LINKCOLOR="1"
	if($AGUSE::LINKCOLOR eq "");
#
# リンクにマウスカーソルを乗せてからポップアップするまでの時間
# (600〜9999ms)
$AGUSE::POPUPTIME="3000"
	if($AGUSE::POPUPTIME+0<600 || $AGUSE::POPUPTIME+0 > 9999);
######################################################################
# Initlize												# comment

sub plugin_aguse_init {
	my $header=<<EOM;
<link rel="stylesheet" href="http://www.aguse.jp/bp/aguse_popup_tool.css" type="text/css" /><script type="text/javascript" src="http://www.aguse.jp/bp/aguse_popup_tool.js#inner=$AGUSE::INNER&amp;color=$AGUSE::LINKCOLOR&amp;wait=$AGUSE::POPUPTIME&amp;" charset="UTF-8" ></script>
EOM
	return ('init'=>1, 'header'=>$header);
}

1;
__DATA__
sub plugin_aguse_setup {
	return(
		ja=>'リンク先チェック for aguse.jp',
		en=>'Link check for aguse.jp (for japanese)',
		require=>'',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/aguse/'
	);
}
__END__

=head1 NAME

aguse.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Link Checker for Visited Borwser

=head1 DESCRIPTION

For safety web link, displays pop-up before actually going investigate.

This plugin is Japanese only

=head1 USAGE

rename to aguse.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/aguse

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/aguse/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/aguse.inc.pl>

=item Use This Service

L<http://www.aguse.jp/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@


@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
