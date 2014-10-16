######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'google_transrate.inc.cgi'
######################################################################
#
# transrate.google.com サービスによる、サイト全体翻訳システム
#
# http://translate.google.com/
#
# 使い方：
#   ・google_transrate.inc.plをgoogle_transrate.inc.cgiにリネーム
#
######################################################################
# Initlize											# comment

sub plugin_google_translate_init {
	my $html;
	&exec_explugin_sub("google_analytics");
	if($GOOGLEANALTYCS::ACCOUNT ne '') {
		$html=<<EOM;
<div style="float:right;font-weight:normal">
<div id="google_translate_element"></div>
<script type="text/javascript"><!--
function googleTranslateElementInit(){new google.translate.TranslateElement({pageLanguage:'$::lang',gaTrack:true,gaId:'$GOOGLEANALTYCS::ACCOUNT',layout:google.translate.TranslateElement.InlineLayout.SIMPLE},'google_translate_element');}
//--></script>
<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
</div>
EOM
	} else {
		$html=<<EOM;
<div style="float:right;font-weight:normal">
<div id="google_translate_element"></div>
<script type="text/javascript"><!--
function googleTranslateElementInit(){new google.translate.TranslateElement({pageLanguage:'$::lang',layout:google.translate.TranslateElement.InlineLayout.SIMPLE},'google_translate_element');}
//--></script>
<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
</div>
EOM
	}
	push(@::addnavi,"googletranslate-nobr::help");
	$::navi{"googletranslate-nobr_html"}=$html;
	return ('init'=>1);
}

1;
__DATA__
sub plugin_google_transrate_setup {
	return(
		ja=>'サイト翻訳システム for transrate.google.com',
		en=>'Site Translate System for transrate.google.com',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/google_transrate/'
	);
}
__END__

=head1 NAME

google_transrate.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Site Translate System for transrate.google.com

=head1 DESCRIPTION

Site Site translate

=head1 USAGE

rename to google_transrate.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/google_transrate

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/google_transrate/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/google_transrate.inc.pl>

=item Use This Service

L<http://google_transrate.com/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@


@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
