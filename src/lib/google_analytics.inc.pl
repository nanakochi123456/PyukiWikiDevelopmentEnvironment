######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'google_analytics.inc.cgi'
######################################################################
#
# google-analytics.com サービスによる、サイトトラッキングシステム
#
# http://google-analytics.com/
#
# 使い方：
#   ・google_analytics.inc.plをgoogle_analytics.inc.cgiにリネーム
#   ・info/setup.cgi に登録したアカウント (UA- で始まるもの) を
#     $GOOGLEANALTYCS::ACCOUNT 変数にセットする。
#   ・ 複数のサブドメインがある場合は、
#     $GOOGLEANALTYCS::MULTISUB に 「.example.com」の形式で記載する。
#   ・複数のトップレベルドメインがある場合、
#     $GOOGLEANALTYCS::MULTITOP=1 をセットする。
#
# 注意：
#   ・合計で１ヶ月500万ビューを超えると課金が発生します。
#
######################################################################

# UA- で始まるアカウントを設定する。
$GOOGLEANALTYCS::ACCOUNT=""
	if($GOOGLEANALTYCS::ACCOUNT eq '');
#
# 複数のサブドメインがある １つのドメインがある場合そのドメインを指定する。
# example : [.example.com]
$GOOGLEANALTYCS::MULTISUB=""
	if($GOOGLEANALTYCS::MULTISUB eq "");
#
# 複数のトップレベルドメインがある場合１
$GOOGLEANALTYCS::MULTITOP=0
	if($GOOGLEANALTYCS::MULTITOP ne 0);
######################################################################
# Initlize											# comment

sub plugin_google_analytics_init {
	if($::form{cmd} eq "" || $::form{cmd} eq "read") {
		if($GOOGLEANALTYCS::ACCOUNT ne '') {
			my $header=<<EOM;
<script type="text/javascript"><!--
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '$GOOGLEANALTYCS::ACCOUNT']);@{[$GOOGLEANALTYCS::MULTISUB ne '' ? "  _gaq.push(['_setDomainName', '$GOOGLEANALTYCS::MULTISUB']);\n" : ""]}@{[$GOOGLEANALTYCS::MULTITOP ne 0 ? "  _gaq.push(['_setDomainName', 'none']);\n  _gaq.push(['_setAllowLinker', true]);\n" : ""]}
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
//--></script>
EOM
			return ('init'=>1, 'header'=>$header);
		}
	}
	return ('init'=>0);
}

1;
__DATA__
sub plugin_google_analytics_setup {
	return(
		ja=>'サイトトラッキングシステム for google-analytics.com',
		en=>'Site Tracking System for google-analytics.com',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/google_analytics/'
	);
}
__END__

=head1 NAME

google_analytics.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Site Tracking System for google-analytics.com

=head1 DESCRIPTION

Site Tracking

=head1 USAGE

rename to google_analytics.inc.cgi

write info/setup.cgi to this value

$GOOGLEANALTYCS::ACCOUNT Account Name

if use multi subdomain, write domain of syntax [.example.com]

$GOOGLEANALTYCS::MULTISUB

if use multi top domain, set this value

$GOOGLEANALTYCS::MULTITOP=1;


=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/google_analytics

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/google_analytics/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/google_analytics.inc.pl>

=item Use This Service

L<http://google_analytics.com/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@


@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
